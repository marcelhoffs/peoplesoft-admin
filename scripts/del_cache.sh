#!/bin/bash

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# ================================================================
# FUNCTIONS
# ================================================================

delete_web_server_cache()
{
  test=$1
  arg1=$2

  cmd1_arg="${arg1:?}/applications/peoplesoft/PORTAL.war/ps/cache/*"

  if [ "$test" = 'Y' ]; then
    echo "$cmd1_arg"
    echo ''
  else
    rm -r $cmd1_arg
  fi
}

# ----------------------------------------------------------------

delete_app_server_cache()
{
  test=$1
  arg1=$2

  cmd1_arg="${arg1:?}/CACHE/*"

  if [ "$test" = 'Y' ]; then
    echo "$cmd1_arg"
    echo ''
  else
    rm -r $cmd1_arg
  fi
}

# ----------------------------------------------------------------

delete_process_scheduler_cache()
{
  test=$1
  arg1=$2

  cmd1_arg="${arg1:?}/CACHE/*"

  if [ "$test" = 'Y' ]; then
    echo "$cmd1_arg"
    echo ''
  else
    rm -r $cmd1_arg
  fi
}

# ----------------------------------------------------------------

delete_cache()
{
  test=$1

  # Web Server
  if [ "$test" = 'Y' ]; then
    echo ''
    echo -e "Web server cache"
    echo -e "----------------"
  fi

  for i in "${!ARR_WEB_BASE[@]}"
  do
    delete_web_server_cache "$test" "${ARR_WEB_BASE[$i]}"
  done

  # Application Server
  if [ "$test" = 'Y' ]; then
    echo -e "Application server cache"
    echo -e "------------------------"
  fi

  for i in "${!ARR_APP_BASE[@]}"
  do
    delete_app_server_cache "$test" "${ARR_APP_BASE[$i]}"
  done

  # Process Scheduler
  if [ "$test" = 'Y' ]; then
    echo -e "Process Scheduler cache"
    echo -e "-----------------------"
  fi

  for i in "${!ARR_PRCS_BASE[@]}"
  do
    delete_process_scheduler_cache "$test" "${ARR_PRCS_BASE[$i]}"
  done
}

# ================================================================
# MAIN
# ================================================================
clear

echo -e "╔════════════════════════════════════════════════════════════╗"
echo -e "║ Delete cache files                                         ║"
echo -e "║ ------------------                                         ║"
echo -e "║ This script will delete all web server, application server ║"
echo -e "║ and process scheduler cache files.                         ║" 
echo -e "╚════════════════════════════════════════════════════════════╝"
echo ''

# Fetch all domains and base paths
source $SCRIPTPATH/functions.sh
get_domains
get_domain_base_paths

# Ask to continue
while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  # Test mode, just to show the paths that will be deleted
  delete_cache 'Y'
    
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

# Delete cache
if [ "$CONTINUE" = 'Y' ]; then
  # Delete cache (no test mode)
  delete_cache 'N'
fi