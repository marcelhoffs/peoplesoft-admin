#!/bin/bash

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# ================================================================
# MAIN
# ================================================================
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

echo ''

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

    psadmin -c start -d "${ARR_APP[$i]}"
  done

  # Start Web Server domains
  for i in "${!ARR_WEB[@]}"; do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Web Server domain:" "${ARR_WEB[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    psadmin -w start -d "${ARR_WEB[$i]}"
  done

  # Start Process Scheduler domains
  echo ''
  for i in "${!ARR_PRCS[@]}"; do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Process Scheduler domain:" "${ARR_PRCS[$i]}"
    echo -e "-------------------------------------------------------".
    echo ''

    psadmin -p start -d "${ARR_PRCS[$i]}"
  done

  echo ''
  echo -e "-------------------------------------------------------"
  echo -e ">> DONE"
  echo -e "-------------------------------------------------------"
  echo ''
fi
