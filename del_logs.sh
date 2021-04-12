#!/bin/bash

delete_web_server_logs()
{
  arg1=$1

  rm -r "${arg1:?}""/*"
}

delete_app_server_logs()
{
  arg1=$1

  rm -r "${arg1:?}""/LOGS/*"
  rm -r "${arg1:?}""/ULOG.*"
}

delete_process_scheduler_logs()
{
  arg1=$1

  rm -r "${arg1:?}""/LOGS/*"
  rm -r "${arg1:?}""/ULOG.*"
}

clear

# Fetch all domains
./domains.sh > /dev/null 2>&1

echo -e "╔============================================================╗"
echo -e "║                                                            ║"
echo -e "║ Delete log files                                           ║"
echo -e "║ ----------------                                           ║"
echo -e "║ This script will delete all web server, application server ║"
echo -e "║ and process scheduler log files.                           ║" 
echo -e "║                                                            ║"
echo -e "╚============================================================╝"
echo ''

# Show Web Server log paths
while read -r web; do
  PATH_WEB_LOG="$PS_CFG_HOME""/webserv/""$web""/servers/PIA/logs"
done < <(cat domains_web | sed -n 1'p' | tr ',' '\n')

# Show Application Server log paths
while read -r app; do
  PATH_APP_LOG="$PS_CFG_HOME""/appserv/""$app"
done < <(cat domains_app | sed -n 1'p' | tr ',' '\n')

# Show Process Scheduler log paths
while read -r prcs; do
  PATH_PRCS_LOG="$PS_CFG_HOME""/appserv/prcs/""$prcs"
done < <(cat domains_prcs | sed -n 1'p' | tr ',' '\n')


while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

if [ "$CONTINUE" = 'Y' ]; then
  # Delete logs
  delete_web_server_logs $PATH_WEB_LOG
  delete_app_server_logs $PATH_APP_LOG
  delete_process_scheduler_logs $PATH_PRCS_LOG
fi