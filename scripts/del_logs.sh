#!/bin/bash

# Constants
IFS=','

# ================================================================
# FUNCTIONS
# ================================================================

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
source ./functions.sh
get_domains
get_domain_base_paths

# Ask to continue
while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  # Test mode, just to show the paths that will be deleted
  
  # Web Server
  echo ''
  echo -e "Web server logs"
  echo -e "---------------"
  for i in "${!arrwebbase[@]}"
  do
    delete_web_server_logs 'Y' "${arrwebbase[$i]}"
  done

  # Application Server
  echo -e "Application server logs"
  echo -e "-----------------------"
  for i in "${!arrappbase[@]}"
  do
    delete_app_server_logs 'Y' "${arrappbase[$i]}"
  done

  # Process Scheduler
  echo -e "Process Scheduler logs"
  echo -e "----------------------"
  for i in "${!arrprcsbase[@]}"
  do
    delete_process_scheduler_logs 'Y' "${arrprcsbase[$i]}"
  done
  
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

# Delete logs
if [ "$CONTINUE" = 'Y' ]; then
  # Delete web server logs
  for i in "${!arrwebbase[@]}"
  do
    delete_web_server_logs 'N' "${arrwebbase[$i]}"
  done

  # Delete application server logs
  for i in "${!arrappbase[@]}"
  do
    delete_app_server_logs 'N' "${arrappbase[$i]}"
  done

  # Delete proces scheduler logs
  for i in "${!arrprcsbase[@]}"
  do
    delete_process_scheduler_logs 'N' "${arrprcsbase[$i]}"
  done
fi