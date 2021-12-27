#!/bin/bash

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

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

# ----------------------------------------------------------------

delete_logs()
{
  test=$1

  # Web Server
  if [ "$test" = 'Y' ]; then
    echo ''
    echo -e "Web server logs"
    echo -e "---------------"
  fi

  for i in "${!ARR_WEB_BASE[@]}"
  do
    delete_web_server_logs "$test" "${ARR_WEB_BASE[$i]}"
  done

  # Application Server
  if [ "$test" = 'Y' ]; then
    echo -e "Application server logs"
    echo -e "-----------------------"
  fi

  for i in "${!ARR_APP_BASE[@]}"
  do
    delete_app_server_logs "$test" "${ARR_APP_BASE[$i]}"
  done

  # Process Scheduler
  if [ "$test" = 'Y' ]; then
    echo -e "Process Scheduler logs"
    echo -e "----------------------"
  fi

  for i in "${!ARR_PRCS_BASE[@]}"
  do
    delete_process_scheduler_logs "$test" "${ARR_PRCS_BASE[$i]}"
  done
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
source $SCRIPTPATH/functions.sh
get_domains
get_domain_base_paths

# Ask to continue
while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  # Test mode, just to show the paths that will be deleted
  delete_logs 'Y'
  
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

# Delete logs
if [ "$CONTINUE" = 'Y' ]; then
  # Delete logs (no test mode)
  delete_logs 'N'
fi