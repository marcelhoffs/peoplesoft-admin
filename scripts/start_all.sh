#!/bin/bash

# Constants
IFS=','

# ================================================================
# MAIN
# ================================================================
clear

echo -e "╔════════════════════════════════════════════════════════════╗"
echo -e "║                                                            ║"
echo -e "║ Start all domains                                          ║"
echo -e "║ -----------------                                          ║"
echo -e "║ This script will start all web server, application server  ║"
echo -e "║ and process scheduler domains.                             ║"
echo -e "║                                                            ║"
echo -e "╚════════════════════════════════════════════════════════════╝"
echo ''

while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

echo ''

if [ "$CONTINUE" = 'Y' ]; then
  # Get PeopleSoft domains
  appdomains=$(psadmin -c list)
  prcsdomains=$(psadmin -p list)
  webdomains=$(psadmin -w list)

  # Put domains in array
  read -a arrapp <<< "$appdomains"
  read -a arrprcs <<< "$prcsdomains"
  read -a arrweb <<< "$webdomains"
  
  # Start Application Server domains
  for app in "${arrapp[@]}" 
  do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Application Server domain:" "$app"
    echo -e "-------------------------------------------------------"
    echo ''

    psadmin -c start -d "$app"
  done  

  # Start Web Server domains
  for web in "${arrweb[@]}" 
  do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Web Server domain:" "$web"
    echo -e "-------------------------------------------------------"
    echo ''

    psadmin -w start -d "$web"
  done  

  # Start Process Scheduler domains
  echo ''
  for prcs in "${arrprcs[@]}" 
  do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Starting Process Scheduler domain:" "$prcs"
    echo -e "-------------------------------------------------------".
    echo ''
    
    psadmin -p start -d "$prcs"
  done  
fi