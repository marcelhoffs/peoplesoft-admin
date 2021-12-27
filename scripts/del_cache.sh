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

# ----------------------------------------------------------------

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

# Fetch all domains
get_domains

# Determine Web Server log paths
for i in "${!arrweb[@]}" 
do
  PATH_WEB_LOG[$i]="${PS_CFG_HOME}/webserv/${arrweb[$i]}"  
done

# Determine Application Server log paths
for i in "${!arrapp[@]}" 
do
  PATH_APP_LOG[$i]="${PS_CFG_HOME}/appserv/${arrapp[$i]}"
done

# Determine Process Scheduler log paths
for i in "${!arrprcs[@]}" 
do
  PATH_PRCS_LOG[$i]="${PS_CFG_HOME}/appserv/prcs/${arrprcs[$i]}"
done

# Ask to continue
while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
 # Test mode, just to show the paths that will be deleted
  
  # Web Server
  echo ''
  echo -e "Web server cache"
  echo -e "----------------"
  for i in "${!PATH_WEB_LOG[@]}"
  do
    delete_web_server_cache 'Y' "${PATH_WEB_LOG[$i]}"
  done

  # Application Server
  echo -e "Application server cache"
  echo -e "------------------------"
  for i in "${!PATH_APP_LOG[@]}"
  do
    delete_app_server_cache 'Y' "${PATH_APP_LOG[$i]}"
  done

  # Process Scheduler
  echo -e "Process Scheduler cache"
  echo -e "-----------------------"
  for i in "${!PATH_PRCS_LOG[@]}"
  do
    delete_process_scheduler_cache 'Y' "${PATH_PRCS_LOG[$i]}"
  done
  
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

# Delete cache
if [ "$CONTINUE" = 'Y' ]; then
  #delete_web_server_cache 'N' "$PATH_WEB_CACHE"
  #delete_app_server_cache 'N' "$PATH_APP_CACHE"
  #delete_process_scheduler_cache 'N' "$PATH_PRCS_CACHE"
fi