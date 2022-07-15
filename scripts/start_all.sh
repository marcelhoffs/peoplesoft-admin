#!/bin/bash

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
EXITCODE=0

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
      echo -e "Usage: start_all.sh [options]"
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

# Show interactive if SILENT is not Y
if [ "$SILENT" != 'Y' ]; then
  clear
  
  echo -e "╔════════════════════════════════════════════════════════════╗"
  echo -e "║ Start all domains                                          ║"
  echo -e "║ -----------------                                          ║"
  echo -e "║ This script will start all web server, application server  ║"
  echo -e "║ and process scheduler domains.                             ║"
  echo -e "╚════════════════════════════════════════════════════════════╝"
  echo ''
  
  while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
    read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
    CONTINUE=${CONTINUE^^}
  done
fi

if [ "$CONTINUE" = 'Y' ]; then
  # Get domains
  source $SCRIPTPATH/functions.sh
  get_domains

  # Start Application Server domains
  for i in "${!ARR_APP[@]}"; do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Application Server domain:" "${ARR_APP[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    APPEXIT=$(psadmin -c start -d "${ARR_APP[$i]}")
    EXITCODE=$((EXITCODE + APPEXIT))
  done

  # Start Web Server domains
  for i in "${!ARR_WEB[@]}"; do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Web Server domain:" "${ARR_WEB[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    WEBEXIT=$(psadmin -w start -d "${ARR_WEB[$i]}")
    EXITCODE=$((EXITCODE + WEBEXIT))
  done

  # Start Process Scheduler domains
  echo ''
  for i in "${!ARR_PRCS[@]}"; do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Process Scheduler domain:" "${ARR_PRCS[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    PRCEXIT=$(psadmin -p start -d "${ARR_PRCS[$i]}")
    EXITCODE=$((EXITCODE + PRCEXIT))
  done

  echo ''
  echo -e "-------------------------------------------------------"
  echo -e ">> DONE"
  echo -e "-------------------------------------------------------"
  echo ''

  echo "$EXITCODE"
fi
