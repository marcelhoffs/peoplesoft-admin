#!/bin/bash

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
  source ./functions.sh
  get_domains
  
  # Start Application Server domains
  for i in "${!arrapp[@]}" 
  do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Application Server domain:" "${arrapp[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    psadmin -c start -d "${arrapp[$i]}"
  done  

  # Start Web Server domains
  for i in "${!arrweb[@]}" 
  do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Web Server domain:" "${arrweb[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    psadmin -w start -d "${arrweb[$i]}"
  done  

  # Start Process Scheduler domains
  echo ''
  for i in "${!arrprcs[@]}" 
  do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Process Scheduler domain:" "${arrprcs[$i]}"
    echo -e "-------------------------------------------------------".
    echo ''

    psadmin -p start -d "${arrprcs[$i]}"
  done  
fi