#!/bin/bash

# Constants
IFS=','

# ================================================================
# MAIN
# ================================================================
clear

echo -e "╔════════════════════════════════════════════════════════════╗"
echo -e "║                                                            ║"
echo -e "║ Stop all domains                                           ║"
echo -e "║ ----------------                                           ║"
echo -e "║ This script will stop all web server, application server   ║"
echo -e "║ and process scheduler domains.                             ║"
echo -e "║                                                            ║"
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

echo ''

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
  # Get PeopleSoft domains
  appdomains=$(psadmin -c list)
  prcsdomains=$(psadmin -p list)
  webdomains=$(psadmin -w list)

  # Put domains in array
  read -a arrapp <<< "$appdomains"
  read -a arrprcs <<< "$prcsdomains"
  read -a arrweb <<< "$webdomains"
  
  # Stop Web Server domains
  echo ''
  for web in "${arrweb[@]}" 
  do
    echo -e ">> Stopping Web Server domain:" "$web"
    psadmin -w $STOP_WEB -d "$web"
  done  

  # Stop Application Server domains
  echo ''
  for app in "${arrapp[@]}" 
  do
    echo -e ">> Stopping Application Server domain:" "$app"
    psadmin -c $STOP_APP -d "$app"
  done  

  # Stop Process Scheduler domains
  echo ''
  for prcs in "${arrprcs[@]}" 
  do
    echo -e ">> Stopping Process Scheduler domain:" "$prcs"
    psadmin -p $STOP_PRCS -d "$prcs"
  done  
fi