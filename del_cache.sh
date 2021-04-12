#!/bin/bash

# ================================================================
# FUNCTIONS
# ================================================================

delete_web_server_cache()
{
  arg1=$1

  rm -r "${arg1:?}/servers/PIA/logs/"*
  rm -r "${arg1:?}/applications/peoplesoft/PORTAL.war/ps/cache/"*
}

delete_app_server_cache()
{
  arg1=$1

  rm -r "${arg1:?}/CACHE/"*
}

delete_process_scheduler_cache()
{
  arg1=$1

  rm -r "${arg1:?}/CACHE/"*
}

# ================================================================
# MAIN
# ================================================================
clear

# Fetch all domains
./domains.sh > /dev/null 2>&1

echo -e "╔════════════════════════════════════════════════════════════╗"
echo -e "║                                                            ║"
echo -e "║ Delete cache files                                         ║"
echo -e "║ ------------------                                         ║"
echo -e "║ This script will delete all web server, application server ║"
echo -e "║ and process scheduler cache files.                         ║" 
echo -e "║                                                            ║"
echo -e "╚════════════════════════════════════════════════════════════╝"
echo ''

# Determine Web Server log paths
while read -r web; do
  PATH_WEB_CACHE="${PS_CFG_HOME}/webserv/${web}"
done < <(cat domains_web | sed -n 1'p' | tr ',' '\n')

# Determine Application Server log paths
while read -r app; do
  PATH_APP_CACHE="${PS_CFG_HOME}/appserv/${app}"
done < <(cat domains_app | sed -n 1'p' | tr ',' '\n')

# Determine Process Scheduler log paths
while read -r prcs; do
  PATH_PRCS_CACHE="${PS_CFG_HOME}/appserv/prcs/${prcs}"
done < <(cat domains_prcs | sed -n 1'p' | tr ',' '\n')

# Ask to continue
while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

# Delete logs
if [ "$CONTINUE" = 'Y' ]; then
  delete_web_server_cache "$PATH_WEB_CACHE"
  delete_app_server_cache "$PATH_APP_CACHE"
  delete_process_scheduler_cache "$PATH_PRCS_CACHE"
fi