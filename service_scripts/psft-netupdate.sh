#!/bin/bash
#
# description: This is a program that is responsible for updating /etc/hosts
# file if the IP Address of the VM is changed
#
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

check_and_update_network() {
    HOST_FILE=/etc/hosts

    # enable Samba service
    if [ -d /etc/systemd ] && [ -f /bin/systemctl ]; then
      /bin/systemctl start smb >/dev/null 2>&1
    else
      /sbin/service smb start >/dev/null 2>&1
    fi

    ret=0
    prog="PeopleSoft Network Updater"
    echo -n $"Starting $prog: "

    # get the current IP address
    cur_ip_address="$(/sbin/ip addr show | grep eth0 | grep inet | tr -s " " | cut -f3 -d " " | cut -f1 -d "/")"
    if [ "$cur_ip_address" != "" ]; then

        # get the host name
        host_name_full=`hostname`
        host_name="$(echo $host_name_full | cut -f1 -d ".")"

        if [ "$host_name" != "localhost" ]; then
            # get the IP address in hosts file
            pre_ip_address=$(cat $HOST_FILE | grep -i $host_name | cut -f1 -d " ")

            # if the current and previous IP's differ, update the hosts file
            # with current IP Address
            if [ "$cur_ip_address" != "$pre_ip_address" ]; then

                # update the hosts file with new IP
                sed -i "/$host_name/d" $HOST_FILE
                sed -i "$ a$cur_ip_address $host_name_full $host_name" $HOST_FILE
            fi
        fi
    fi
    [ $ret -eq 0 ] && success || failure
    echo
    return $ret
}

stop() {
    ret=0
    prog="PeopleSoft Network Updater"
    echo -n $"Stopping $prog: "

    [ $ret -eq 0 ] && success || failure
    echo
    return $ret
}

dostatus() {
    echo "PeopleSoft Network Updater is Running"
    return 0
}

# Set path if path not set (if called from /etc/rc)
case $PATH in
    "") PATH=/bin:/usr/bin:/sbin:/etc
        export PATH
        ;;
esac


if [ "$(id -u)" != "0" ]; then
    echo "You must be root to run this script."
    exit 1
fi

# See how we were called
case "$1" in
    start)
        check_and_update_network
        ;;
    stop)
        stop
        ;;
    status)
        dostatus
        ;;

    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
esac