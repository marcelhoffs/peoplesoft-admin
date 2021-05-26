#!/bin/bash

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
PIADOM=peoplesoft
PIA_ADMIN=psadm2
PIA_CFG_HOME=/home/psadm2/psft/pt/8.58
PIA_PS_HOME=/opt/oracle/psft/pt/ps_home8.58.10
PROG="PeopleSoft PIA Domain $PIADOM"

check_pia_installed() {
  local ret=0

  if [ -f $PIA_CFG_HOME/webserv/$PIADOM/config/config.xml ]; then
    ret=1
  else
    ret=0
  fi
  return $ret
}

log_message() {
  echo "[LOG]  $(date +'%b %d %H:%M:%S') ${0##*/}: $*" >> $LOG_FILE
}

# function start PIA domain
start_pia () {
  ret=0

  echo -n $"Starting $PROG: "

  log_message "Starting $PROG"

  # check if PIA is configured
  check_pia_installed
  if [ $? == 1 ]; then
    # check if the domain is already started
    status=`ps -ef | grep java | grep $PIA_ADMIN | grep Dweblogic.Name=PIA`
    if [ "$status" != "" ]; then
      log_message "$PROG has already been started" >/dev/null 2>&1
      success
      ret=0
    else
      su - $PIA_ADMIN -c "$PIA_CFG_HOME/webserv/$PIADOM/bin/startPIA.sh" 1>>$LOG_FILE 2>&1
      ret=$?
      [ $ret -eq 0 ] && success || failure
    fi
    log_message "Started $PROG"
  else
    log_message "$PROG is not configured on this host"
    failure
    ret=1
  fi
  echo
  return $ret
}

# function stop PIA domain
stop_pia () {
  ret=0

  echo -n $"Stopping $PROG: "

  log_message "Stopping $PROG"

  # check if PIA is configured
  check_pia_installed
  if [ $? == 1 ]; then
    # check if the domain is already stopped
    status=`ps -ef | grep java | grep $PIA_ADMIN | grep Dweblogic.Name=PIA`
    if [ "$status" == "" ]; then
      log_message "$PROG has already been stopped" >/dev/null 2>&1
      success
      ret=0
    else
      su - $PIA_ADMIN -c "$PIA_CFG_HOME/webserv/$PIADOM/bin/stopPIA.sh" 1>>$LOG_FILE 2>&1
      ret=$?
      [ $ret -eq 0 ] && success || failure
    fi
    log_message "Stopped $PROG"
  else
    log_message "$PROG is not configured on this host"
    failure
    ret=1
  fi
  echo
  return $ret
}

start() {

    # start the PIA domain
    start_pia
    return $?
}

stop() {

    # stop the PIA domain
    stop_pia
    return $?
}

restart() {
    stop
    start
}

dostatus() {
  # check if PIA is configured
  check_pia_installed
  if [ $? == 1 ]; then
    # check if the PIA domain is running
    status=`ps -ef | grep java | grep $PIA_ADMIN | grep Dweblogic.Name=PIA`
    if [ "$status" == "" ]; then
      echo "$PROG is Down"
    else
      echo "$PROG is Up"
    fi
  else
    echo "$PROG is Not Configured on this Host"
  fi
}

# Set path if path not set (if called from /etc/rc)
case $PATH in
    "") PATH=/bin:/usr/bin:/sbin:/etc
        export PATH
        ;;
esac



# See how we were called
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        dostatus
        ;;

    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
esac