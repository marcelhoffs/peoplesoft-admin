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

while getopts ':yh' OPTION; do
  case "$OPTION" in
    y)
      SILENT='Y'
      CONTINUE='Y'
      ;;
    h)
      echo -e "Usage: del_logs.sh [options]"
      echo -e ""
      echo -e "Options:"
      echo -e "  -y    execute without confirmation"
      echo -e "  -h    display this help message"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Fetch all domains and base paths
source $SCRIPTPATH/functions.sh
get_domains
get_domain_base_paths

# Show interactive if SILENT is not Y
if [ "$SILENT" != 'Y' ]; then
  clear

  echo -e "╔════════════════════════════════════════════════════════════╗"
  echo -e "║ Delete log files                                           ║"
  echo -e "║ ----------------                                           ║"
  echo -e "║ This script will delete all web server, application server ║"
  echo -e "║ and process scheduler log files.                           ║"
  echo -e "╚════════════════════════════════════════════════════════════╝"

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
fi

# Delete logs
if [ "$CONTINUE" = 'Y' ]; then
  # Delete logs (no TEST mode)
  delete_logs 'N'
fi
