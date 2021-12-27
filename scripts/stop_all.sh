#!/bin/bash

# Constants
IFS=','

# ================================================================
# FUNCTIONS
# ================================================================

get_domains()
{
  # Get PeopleSoft domains
  appdomains=$(psadmin -c list)
  prcsdomains=$(psadmin -p list)
  webdomains=$(psadmin -w list)

  # Put domains in array
  read -a arrapp <<< "$appdomains"
  read -a arrprcs <<< "$prcsdomains"
  read -a arrweb <<< "$webdomains"
}

# ================================================================
# MAIN
# ================================================================
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
  # Get domains
  get_domains
  
  # Stop Web Server domains
  for web in "${!arrweb[@]}" 
  do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Stopping Web Server domain:" "${arrweb[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''

    psadmin -w $STOP_WEB -d "${arrweb[$i]}"
  done  

  # Stop Application Server domains
  for i in "${!arrapp[@]}" 
  do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Stopping Application Server domain:" "${arrapp[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''    

    psadmin -c $STOP_APP -d "${arrapp[$i]}"
  done  

  # Stop Process Scheduler domains
  for i in "${!arrprcs[@]}" 
  do
    echo ''
    echo -e "-------------------------------------------------------"
    echo -e ">> Stopping Process Scheduler domain:" "${arrprcs[$i]}"
    echo -e "-------------------------------------------------------"
    echo ''
    
    psadmin -p $STOP_PRCS -d "${arrprcs[$i]}"
  done  
fi