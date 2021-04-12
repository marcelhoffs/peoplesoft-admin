#!/bin/bash

clear

echo -e "==========================================================="
echo -e ""
echo -e " Start all domains"
echo -e " -----------------"
echo -e " This script will start all web server, application server"
echo -e " and process scheduler domains."
echo -e ""
echo -e "==========================================================="
echo ''

while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

echo ''

if [ "$CONTINUE" = 'Y' ]; then
  # Fetch all domains
  ./domains.sh > /dev/null 2>&1

  # Start Application Server domains
  echo -e ">> Starting all Application Server domains"
  < domains_app sed -n 1'p' | tr ',' '\n' | while read -r app; do
    psadmin -c start -d "$app"
  done

  # Start Web Server domains
  echo ''
  echo -e ">> Starting all Web Server domains"
  < domains_web sed -n 1'p' | tr ',' '\n' | while read -r web; do
    psadmin -w start -d "$web"
  done

  # Start Process Scheduler domains
  echo ''
  echo -e ">> Starting all Process Scheduler domains"
  < domains_prcs sed -n 1'p' | tr ',' '\n' | while read -r prcs; do
    psadmin -p start -d "$prcs"
  done
fi