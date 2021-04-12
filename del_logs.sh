#!/bin/bash

delete_directory()
{
    arg1=$1

    echo ''
    echo -e ">> Deleting directory: ""$arg1"
    rm -r "$arg1"
}

clear

# Fetch all domains
./domains.sh > /dev/null 2>&1

echo -e "=========================================================="
echo -e ""
echo -e " Delete log files"
echo -e " ----------------"
echo -e " This script will delete all web server, application server"
echo -e " and process scheduler log files."
echo -e ""

# Show Web Server log paths
echo -e "  Web Server logs"
echo -e "  ---------------"
while read -r web; do
  PATH_WEB_LOG="$PS_CFG_HOME""/webserv/""$web""/servers/PIA/logs/*"
  echo -e "  ""$PATH_WEB_LOG"
done < <(cat domains_web | sed -n 1'p' | tr ',' '\n')

# Show Application Server log paths
echo ''
echo -e "  Application Server logs"
echo -e "  -----------------------"
while read -r app; do
  PATH_APP_LOG="$PS_CFG_HOME""/appserv/""$app""/LOGS/*"
  echo -e "  ""$PATH_APP_LOG"
done < <(cat domains_app | sed -n 1'p' | tr ',' '\n')

# Show Process Scheduler log paths
echo ''
echo -e "  Process Scheduler logs"
echo -e "  ----------------------"
while read -r prcs; do
  PATH_PRCS_LOG="$PS_CFG_HOME""/appserv/prcs/""$prcs""/LOGS/*"
  echo -e "  ""$PATH_PRCS_LOG"; 
done < <(cat domains_prcs | sed -n 1'p' | tr ',' '\n')

echo -e ""
echo -e "=========================================================="
echo ''

while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

if [ "$CONTINUE" = 'Y' ]; then
  # Delete Web Server logs
  delete_directory $PATH_WEB_LOG

  # Delete Application Server logs
  delete_directory $PATH_APP_LOG

  # Delete Process Scheduler logs
  delete_directory $PATH_PRCS_LOG
fi