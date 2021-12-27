#!/bin/bash

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

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
  # Fetch all domains
  #sh $SCRIPTPATH/domains.sh > /dev/null 2>&1

  # Stop Web Server domains
  #echo -e ">> Stopping all Web Server domains"
  #< psadmin -w list | while read -r web; do
  #  psadmin -w $STOP_WEB -d "$web"
  #done

  # Stop all Application Server domains
  #echo ''
  #echo -e ">> Stopping all Application Server domains"
  #< psadmin -c list | while read -r app; do
  #  psadmin -c $STOP_APP -d "$app"
  #echo 'psadmin -C' "$STOP_APP" '-d' "$app"
  #done

  # Stop all Process Scheduler domains
  #echo ''
  #echo -e ">> Stopping all Process Scheduler domains"
  #< psadmin -p list | while read -r prcs; do
  #  psadmin -p $STOP_PRCS -d "$prcs"
  #done

  psadmin -c list | sed -n 1'p' | tr ',' '\n' | while read word; do
    echo $word
  done
fi