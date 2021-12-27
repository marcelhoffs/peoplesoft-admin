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

get_domain_base_paths()
{
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
}

# ----------------------------------------------------------------

delete_web_server_logs()
{
  test=$1
  arg1=$2

  cmd1_arg="${arg1:?}/servers/PIA/logs/*"
 
  if [ "$test" = 'Y' ]; then
    echo "$cmd1_arg"
    echo ''
  else
    rm -r $cmd1_arg
  fi
}

# ----------------------------------------------------------------

delete_app_server_logs()
{
  test=$1
  arg1=$2

  cmd1_arg="${arg1:?}/LOGS/*"
  cmd2_arg="${arg1:?}/ULOG.*"

  if [ "$test" = 'Y' ]; then
    echo "$cmd1_arg"
    echo "$cmd2_arg"
    echo ''
  else
    rm -r $cmd1_arg
    rm -r $cmd2_arg
  fi
}

# ----------------------------------------------------------------

delete_process_scheduler_logs()
{
  test=$1
  arg1=$2

  cmd1_arg="${arg1:?}/LOGS/*"
  cmd2_arg="${arg1:?}/ULOG.*"

  if [ "$test" = 'Y' ]; then
    echo "$cmd1_arg"
    echo "$cmd2_arg"
    echo ''
  else
    rm -r $cmd1_arg
    rm -r $cmd2_arg
  fi
}

# ================================================================
# MAIN
# ================================================================
clear

echo -e "╔════════════════════════════════════════════════════════════╗"
echo -e "║ Delete log files                                           ║"
echo -e "║ ----------------                                           ║"
echo -e "║ This script will delete all web server, application server ║"
echo -e "║ and process scheduler log files.                           ║" 
echo -e "╚════════════════════════════════════════════════════════════╝"
echo ''

# Fetch all domains and base paths
get_domains
get_domain_base_paths

# Ask to continue
while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  # Test mode, just to show the paths that will be deleted
  
  # Web Server
  echo ''
  echo -e "Web server logs"
  echo -e "---------------"
  for i in "${!PATH_WEB_LOG[@]}"
  do
    delete_web_server_logs 'Y' "${PATH_WEB_LOG[$i]}"
  done

  # Application Server
  echo -e "Application server logs"
  echo -e "-----------------------"
  for i in "${!PATH_APP_LOG[@]}"
  do
    delete_app_server_logs 'Y' "${PATH_APP_LOG[$i]}"
  done

  # Process Scheduler
  echo -e "Process Scheduler logs"
  echo -e "----------------------"
  for i in "${!PATH_PRCS_LOG[@]}"
  do
    delete_process_scheduler_logs 'Y' "${PATH_PRCS_LOG[$i]}"
  done
  
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

# Delete logs
if [ "$CONTINUE" = 'Y' ]; then
  # Delete web server logs
  for i in "${!PATH_WEB_LOG[@]}"
  do
    delete_web_server_logs 'N' "${PATH_WEB_LOG[$i]}"
  done

  # Delete application server logs
  for i in "${!PATH_APP_LOG[@]}"
  do
    delete_app_server_logs 'N' "${PATH_APP_LOG[$i]}"
  done

  # Delete proces scheduler logs
  for i in "${!PATH_PRCS_LOG[@]}"
  do
    delete_process_scheduler_logs 'N' "${PATH_PRCS_LOG[$i]}"
  done
fi