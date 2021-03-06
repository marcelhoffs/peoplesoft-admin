#!/bin/bash

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# ================================================================
# FUNCTIONS
# ================================================================

delete_web_server_logs() {
  TEST=$1
  ARG1=$2

  CMD1_ARG="${ARG1:?}/servers/PIA/logs/*"

  if [ "$TEST" = 'Y' ]; then
    # Show path
    echo "$CMD1_ARG"
  else
    # Delete
    rm -r $CMD1_ARG
  fi
}

# ----------------------------------------------------------------

delete_app_server_logs() {
  TEST=$1
  ARG1=$2

  CMD1_ARG="${ARG1:?}/LOGS/*"
  CMD2_ARG="${ARG1:?}/ULOG.*"

  if [ "$TEST" = 'Y' ]; then
    # Show path
    echo "$CMD1_ARG"
    echo "$CMD2_ARG"
  else
    # Delete
    rm -r $CMD1_ARG
    rm -r $CMD2_ARG
  fi
}

# ----------------------------------------------------------------

delete_process_scheduler_logs() {
  TEST=$1
  ARG1=$2

  CMD1_ARG="${ARG1:?}/LOGS/*"
  CMD2_ARG="${ARG1:?}/ULOG.*"

  if [ "$TEST" = 'Y' ]; then
    # Show path
    echo "$CMD1_ARG"
    echo "$CMD2_ARG"
  else
    # Delete
    rm -r $CMD1_ARG
    rm -r $CMD2_ARG
  fi
}

# ----------------------------------------------------------------

delete_logs() {
  TEST=$1

  # Web Server
  for i in "${!ARR_WEB_BASE[@]}"; do
    if [ "$TEST" = 'Y' ] && [ $i = 0 ]; then
      echo ''
      echo -e "Web server logs"
      echo -e "---------------"
    fi
    delete_web_server_logs "$TEST" "${ARR_WEB_BASE[$i]}"
  done

  # Application Server
  for i in "${!ARR_APP_BASE[@]}"; do
    if [ "$TEST" = 'Y' ] && [ $i = 0 ]; then
      echo ''
      echo -e "Application server logs"
      echo -e "-----------------------"
    fi
    delete_app_server_logs "$TEST" "${ARR_APP_BASE[$i]}"
  done

  # Process Scheduler
  for i in "${!ARR_PRCS_BASE[@]}"; do
    if [ "$TEST" = 'Y' ] && [ $i = 0 ]; then
      echo ''
      echo -e "Process Scheduler logs"
      echo -e "----------------------"
    fi
    delete_process_scheduler_logs "$TEST" "${ARR_PRCS_BASE[$i]}"
  done
}

# ================================================================
# MAIN
# ================================================================
clear

echo -e "??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"
echo -e "??? Delete log files                                           ???"
echo -e "??? ----------------                                           ???"
echo -e "??? This script will delete all web server, application server ???"
echo -e "??? and process scheduler log files.                           ???"
echo -e "??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"

# Fetch all domains and base paths
source $SCRIPTPATH/functions.sh
get_domains
get_domain_base_paths

# TEST mode, just to show the paths that will be deleted
delete_logs 'Y'

echo ''
echo -e "--------------------------------------------------------------"
echo ''

# Ask to continue
while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

# Delete logs
if [ "$CONTINUE" = 'Y' ]; then
  # Delete logs (no TEST mode)
  delete_logs 'N'
fi
