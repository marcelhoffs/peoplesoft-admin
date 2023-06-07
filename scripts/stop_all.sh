#!/bin/bash

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# ================================================================
# MAIN
# ================================================================

while getopts ':yfh' OPTION; do
  case "$OPTION" in
    y)
      SILENT='Y'
      CONTINUE='Y'
      ;;
    f)
      FORCE='Y'
      ;;
    h)
      echo -e "Usage: start_all.sh [options]"
      echo -e ""
      echo -e "Options:"
      echo -e "  -y    execute without confirmation"
      echo -e "  -f    forcefully shutdown services"
      echo -e "  -h    display this help message"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Show interactive if SILENT is not Y
if [ "$SILENT" != 'Y' ]; then
  clear
  
  echo -e "╔════════════════════════════════════════════════════════════╗"
  echo -e "║ Stop all domains                                           ║"
  echo -e "║ ----------------                                           ║"
  echo -e "║ This script will stop all web server, application server   ║"
  echo -e "║ and process scheduler domains.                             ║"
  echo -e "╚════════════════════════════════════════════════════════════╝"
  echo ''
  
  while [ "$FORCE" != 'Y' ] && [ "$FORCE" != 'N' ]; do
    read -r -p 'Do you want to forcefully shutdown? [Y/N]: ' FORCE
    FORCE=${FORCE^^}
  done
  
  echo ''
  
  while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
    read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
    CONTINUE=${CONTINUE^^}
  done
fi

# Determine shutdown command
if [ "$FORCE" = 'Y' ]; then
  STOP_WEB='shutdown!'
  STOP_APP='kill'
  STOP_PRCS='kill'
else
  STOP_WEB='shutdown'
  STOP_APP='stop'
  STOP_PRCS='stop'
fi

if [ "$CONTINUE" = 'Y' ]; then
  # Get domains
  source $SCRIPTPATH/functions.sh
  get_domains

  # Stop Web Server domains
  for i in "${!ARR_WEB[@]}"; do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Stopping Web Server domain:" "${ARR_WEB[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    psadmin -w $STOP_WEB -d "${ARR_WEB[$i]}"
  done

  # Stop Application Server domains
  for i in "${!ARR_APP[@]}"; do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Stopping Application Server domain:" "${ARR_APP[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    psadmin -c $STOP_APP -d "${ARR_APP[$i]}"
  done

  # Stop Process Scheduler domains
  for i in "${!ARR_PRCS[@]}"; do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Stopping Process Scheduler domain:" "${ARR_PRCS[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    psadmin -p $STOP_PRCS -d "${ARR_PRCS[$i]}"
  done

  echo ''
  echo -e "-------------------------------------------------------"
  echo -e ">> DONE"
  echo -e "-------------------------------------------------------"
  echo ''
  exit 0
fi
