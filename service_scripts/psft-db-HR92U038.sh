#!/bin/bash
#
# description: This is a program that is responsible for taking care of
# configuring the Oracle Database 12g and its associated
# services.
#

echo_status() {
echo "$1"
}

# Log that something succeeded
success() {
  echo_status "Success"
  return 0
}

# Log that something failed
failure() {
  local rc=$?
  echo_status "Failed: exit_code: $rc"
  return $rc
}

unset TMPDIR

SCRIPT_NAME=$(basename $(readlink -nf $0))
script_name_temp=${SCRIPT_NAME%.*}
if [ "$(id -u)" == "0" ]; then
  log_file_dir=/var/log
else
  log_file_dir=$(dirname $SCRIPT_NAME)
fi
LOG_FILE=${log_file_dir}/${script_name_temp}.log
CONTAINER_NAME=CDBHCM
DATABASE_NAME=HR92U038
ORACLE_OWNER=oracle2
ORACLE_HOME=/opt/oracle/psft/db/oracle-server/19.3.0.0
ORACLE_SID=$CONTAINER_NAME
LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
PATH=$ORACLE_HOME/bin:$PATH

THIS_OS="THIS_OS-not-initialized"
THIS_OS=`uname -s`

log_message() {
    echo "[LOG]  $(date +'%b %d %H:%M:%S') ${0##*/}: $*" >> $LOG_FILE
}

get_listener_name() {
  listener_name=$(cat $ORACLE_HOME/network/admin/listener.ora | grep "^[a-zA-Z].*=$" | cut -f1 -d '=')
  echo $listener_name
}

# function start listener
start_listener () {
    export ORACLE_HOME
    prog="PeopleSoft Database Listener"
    echo -n $"Starting $prog: "

    LISTENER_NAME=$(get_listener_name)
    log_message "Starting $prog"

    case "$THIS_OS" in
       SunOS ) su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/lsnrctl start $LISTENER_NAME"            1>>$LOG_FILE 2>&1
               ;;
           * ) su -s /bin/bash $ORACLE_OWNER -c "$ORACLE_HOME/bin/lsnrctl start $LISTENER_NAME" 1>>$LOG_FILE 2>&1
               ;;
    esac
    ret=$?
    [ $ret -eq 0 ] && success || failure
    echo
    log_message "Started $prog"

    return $ret
}

# function stop listener
stop_listener () {
    ret=0
    export ORACLE_HOME
    prog="PeopleSoft Database Listener"
    echo -n $"Stopping $prog: "

    LISTENER_NAME=$(get_listener_name)
    log_message "Stopping $prog"
    # check if the listener is already stopped
    status=`ps -ef | grep tns | grep $LISTENER_NAME`
    if [ "$status" == "" ]; then
        log_warn "$prog has already been stopped" >/dev/null 2>&1
        success
        ret=1
    else
        case "$THIS_OS" in
           SunOS ) su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/lsnrctl stop $LISTENER_NAME"            1>>$LOG_FILE 2>&1
                   ;;
               * ) su -s /bin/bash $ORACLE_OWNER -c "$ORACLE_HOME/bin/lsnrctl stop $LISTENER_NAME" 1>>$LOG_FILE 2>&1
                   ;;
        esac
        ret=$?
        [ $ret -eq 0 ] && success || failure
    fi
    echo
    log_message "Stopped $prog"

    return $ret
}

start_db_container() {
    export ORACLE_SID ORACLE_HOME
    export TNS_ADMIN=$ORACLE_HOME/network/admin

    prog="PeopleSoft Container Database $CONTAINER_NAME"
    echo -n $"Starting $prog: "

    log_message "Starting $prog: "
    su -s /bin/bash  $ORACLE_OWNER -c "$ORACLE_HOME/bin/sqlplus -s /nolog" <<SQL 2>&1>> $LOG_FILE
WHENEVER SQLERROR EXIT 1
connect / as sysdba
startup
SQL
    ret=$?
    [ $ret -eq 0 ] && success || failure
    echo
    log_message "Started $prog"

    return $ret
}

stop_db_container() {
    export ORACLE_SID ORACLE_HOME
    prog="PeopleSoft Container Database $CONTAINER_NAME"
    echo -n $"Stopping $prog: "

    log_message "Stopping $prog"
    su -s /bin/bash  $ORACLE_OWNER -c "$ORACLE_HOME/bin/sqlplus -s /nolog" <<SQL 2>&1>> $LOG_FILE
WHENEVER SQLERROR EXIT 1
connect / as sysdba
shutdown immediate
SQL
    ret=$?
    [ $ret -eq 0 ] && success || failure
    echo
    log_message "Stopped $prog"

    return $ret
}

get_database_status() {
    export ORACLE_SID ORACLE_HOME

    CHECK_PDB_SCRIPT=/tmp/checkpdb.sql

cat >> $CHECK_PDB_SCRIPT <<-EOF
set termout on
set echo off
set verify off
set feedback off
set heading off
select 'CDB' from v\$database where name='&1' and cdb='YES';
select 'PDBSEED' From v\$pdbs where name='PDB\$SEED' and open_mode = 'READ ONLY';
select '&2' , open_mode From v\$pdbs where name='&2' and open_mode in ('READ WRITE','MOUNTED');
exit
EOF
chmod 755 $CHECK_PDB_SCRIPT

    log_message "Getting the status of PDB $DATABASE_NAME"

    STATUS_FILE=/tmp/$DATABASE_NAME.status
    su -s /bin/bash  $ORACLE_OWNER -c "$ORACLE_HOME/bin/sqlplus -s /nolog" <<SQL 2>&1> $STATUS_FILE
connect / as sysdba
@$CHECK_PDB_SCRIPT $CONTAINER_NAME $DATABASE_NAME
SQL
rm -rf $CHECK_PDB_SCRIPT
}

# This function is for use in systemd-enabled environment to check the status
# If DB and Listener are both up, then the start function must not attempt to
# start them and should, instead, return 0. This is needed by systemd to set
# active status for the service.
# If both DB and the listener are up, the value 0 will be returned.
# If only the DB is down, the value 1 will be returned.
# If only the listener is down, the value 2 will be returned.
# If both DB and the listener are down, the value 3 will be returned.
# The start function will perform appropriate actions, based on these return values.
check_db_status() {
    export ORACLE_SID ORACLE_HOME
    local chk_ret=0
    local chk_db_ret=0
    local chk_lsnr_ret=0

    # check if the container database is running
    status=`ps -ef | grep ora_pmon_$CONTAINER_NAME | grep -v grep`
    if [ "$status" == "" ]; then
        chk_db_ret=1
    else
        get_database_status
        DB_STATUS_FILE=/tmp/$DATABASE_NAME.status
        if [ -f $DB_STATUS_FILE ]; then
          if grep -q CDB $DB_STATUS_FILE && grep -q PDBSEED $DB_STATUS_FILE; then
            if grep -q $DATABASE_NAME $DB_STATUS_FILE; then
              if grep -q MOUNTED $DB_STATUS_FILE; then
                chk_db_ret=1
              else
                chk_db_ret=0
              fi
            else
              chk_db_ret=1
            fi
          else
            chk_db_ret=1
          fi
          rm -rf $DB_STATUS_FILE >/dev/null
        else
          chk_db_ret=1
        fi
    fi
    # check if the listener is running
    LISTENER_NAME=$(get_listener_name)
    status=`ps -ef | grep tns | grep $LISTENER_NAME`
    if [ "$status" == "" ]; then
        chk_lsnr_ret=1
    fi

   # Only the DB is down
   if [ $chk_db_ret -eq 1 ] && [ $chk_lsnr_ret -eq 0 ]; then
     chk_ret=1
   # Only the listener is down
   elif [ $chk_db_ret -eq 0 ] && [ $chk_lsnr_ret -eq 1 ]; then
     chk_ret=2
   # Both DB and the listener are down
   elif [ $chk_db_ret -eq 1 ] && [ $chk_lsnr_ret -eq 1 ]; then
     chk_ret=3
   fi

   return $chk_ret
}

start() {
    # Systemd does not activate a service until it is started (or after reboot).
    # The current implementation of DPK does not start the DB by starting the
    # configured psft-db service but uses a ruby provider (executed by Puppet)
    # to start it. But the Systemd psft-db service needs to be activated (by DPK),
    # so that it can be used to stop/start the DB, right after the DPK deployment,
    # So if start is called when the DB is already running, the script should return
    # status-code 0, so that systemd marks it as an active service.

    local start_ret=0
    local start_db_ret=0
    local start_lsnr_ret=0

    #Check whether DB and/or listener are up
    check_db_status
    start_ret=$?
    # if both listener and db are up, then return 0
    if [ $start_ret -eq 0 ]; then
      return $start_ret
    fi

    # First start the NET Listener, because it seems to take time to initialize
    if [ $start_ret -gt 1 ]; then
      start_listener
      start_lsnr_ret=$?
    fi

    # start the container
    if [ $start_ret -eq 1 ] || [ $start_ret -eq 3 ]; then
      start_db_container
      start_db_ret=$?
    fi

    local start_final_ret=$(( start_lsnr_ret | start_db_ret ))
    return $start_final_ret
}

stop() {

    # stop NET Listner first
    stop_listener
    list_ret=$?

    # stop the database
    stop_db_container
    db_ret=$?

    final_ret=$(( list_ret | db_ret ))
    return $final_ret
}

dostatus() {
    export ORACLE_SID ORACLE_HOME

    # check if the container database is running
    status=`ps -ef | grep ora_pmon_$CONTAINER_NAME | grep -v grep`
    if [ "$status" == "" ]; then
        echo "PeopleSoft Container Database $CONTAINER_NAME Status is Down"
    else
        echo "PeopleSoft Container Database $CONTAINER_NAME Status is Up"
        get_database_status
        DB_STATUS_FILE=/tmp/$DATABASE_NAME.status
        if [ -f $DB_STATUS_FILE ]; then
          if grep -q CDB $DB_STATUS_FILE && grep -q PDBSEED $DB_STATUS_FILE; then
            if grep -q $DATABASE_NAME $DB_STATUS_FILE; then
              if grep -q MOUNTED $DB_STATUS_FILE; then
                echo "PeopleSoft Pluggable Database $DATABASE_NAME Status is Closed"
              else
                echo "PeopleSoft Pluggable Database $DATABASE_NAME Status is Open"
              fi
            else
              echo "PeopleSoft Pluggable Database $DATABASE_NAME Does not Exists"
            fi
          else
            echo "PeopleSoft Pluggable Database $DATABASE_NAME Status is UNKNOWN"
          fi
          rm -rf $DB_STATUS_FILE >/dev/null
        else
          echo "PeopleSoft Pluggable Database $DATABASE_NAME Status is UNKNOWN"
        fi
    fi
    # check if the listener is running
    LISTENER_NAME=$(get_listener_name)
    status=`ps -ef | grep tns | grep $LISTENER_NAME`
    if [ "$status" == "" ]; then
        echo "PeopleSoft Database Listener is Down"
    else
        echo "PeopleSoft Database Listener is Up"
    fi
}

##### main ##############################################################################
# Set path if path not set (if called from /etc/rc)
case $PATH in
    "") PATH=/bin:/usr/bin:/sbin:/etc
        export PATH
        ;;
esac

export LC_ALL=C



# See how we were called
case "$1" in
    start)
      start
      ;;
    stop)
      stop
      ;;
    restart|reload)
      restart
        ;;
    status)
      dostatus
      ;;
    *)
      echo "Usage: $0 {start|stop|restart|status}"
      exit 1
esac