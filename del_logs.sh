#!/bin/bash

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
< domains_web sed -n 1'p' | tr ',' '\n' | while read -r web; do
  PATH_WEB_LOG="$web"": ""$PS_CFG_HOME""/webserv/""$web""/servers/PIA/logs/*"
  echo -e "  ""$PATH_WEB_LOG"
done

# Show Application Server log paths
echo ''
echo -e "  Application Server logs"
echo -e "  -----------------------"
< domains_app sed -n 1'p' | tr ',' '\n' | while read -r app; do
  PATH_APP_LOG="$app"": ""$PS_CFG_HOME""/appserv/""$app""/LOGS/*"
  echo -e "  ""$PATH_APP_LOG"
done

# Show Process Scheduler log paths
echo ''
echo -e "  Process Scheduler logs"
echo -e "  ----------------------"
< domains_prcs sed -n 1'p' | tr ',' '\n' | while read -r prcs; do
  PATH_PRCS_LOG="$prcs"": ""$PS_CFG_HOME""/appserv/prcs/""$prcs""/LOGS/*"
  echo -e "  ""$PATH_PRCS_LOG"
done

echo -e ""
echo -e "=========================================================="
echo ''

while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

if [ "$CONTINUE" = 'Y' ]; then
  # Delete Web Server logs
  rm -r "$PATH_WEB_LOG"

  # Delete Application Server logs
  rm -r "$PATH_APP_LOG"

  # Delete Process Scheduler logs
  rm -r "$PATH_PRCS_LOG"
fi