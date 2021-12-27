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

delete_web_server_logs()
{
  test=$1
  arg1=$2

  cmd1_arg="${arg1:?}/servers/PIA/logs/*"
  #cmd2_arg="${arg1:?}/applications/peoplesoft/PSIGW.war/WEB-INF/"*

  if [ "$test" = 'Y' ]; then
    echo "$cmd1_arg"
    #echo "$cmd2_arg"
    
    echo ''
  else
    rm -r $cmd1_arg
    #rm -r $cmd2_arg
  fi
}
#
#delete_app_server_logs()
#{
#  test=$1
#  arg1=$2
#
#  cmd1_arg="${arg1:?}/LOGS/*"
#  cmd2_arg="${arg1:?}/ULOG.*"
#
#  if [ "$test" = 'Y' ]; then
#    echo -e "Application server logs"
#    echo -e "-----------------------"
#
#    # Paths
#    echo "$cmd1_arg"
#    echo "$cmd2_arg"
#
#    echo ''
#  else
#    rm -r $cmd1_arg
#    rm -r $cmd2_arg
#  fi
#}
#
#delete_process_scheduler_logs()
#{
#  test=$1
#  arg1=$2
#
#  cmd1_arg="${arg1:?}/LOGS/*"
#  cmd2_arg="${arg1:?}/ULOG.*"
#
#  if [ "$test" = 'Y' ]; then
#    echo -e "Process Scheduler logs"
#    echo -e "----------------------"
#    
#    # Paths
#    echo "$cmd1_arg"
#    echo "$cmd2_arg"
#    
#    echo ''
#  else
#    rm -r $cmd1_arg
#    rm -r $cmd2_arg
#  fi
#}

# ================================================================
# MAIN
# ================================================================
clear

echo -e "╔════════════════════════════════════════════════════════════╗"
echo -e "║                                                            ║"
echo -e "║ Delete log files                                           ║"
echo -e "║ ----------------                                           ║"
echo -e "║ This script will delete all web server, application server ║"
echo -e "║ and process scheduler log files.                           ║" 
echo -e "║                                                            ║"
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
  #delete_web_server_logs 'Y' "$PATH_WEB_LOG"
  
  for i in "${!PATH_WEB_LOG[@]}"
  do
    echo -e "Web server logs"
    echo -e "---------------"

    delete_web_server_logs 'Y' "${PATH_WEB_LOG[$i]}"
  done

  #delete_process_scheduler_logs 'Y' "$PATH_PRCS_LOG"
  
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done
#
## Delete logs
#if [ "$CONTINUE" = 'Y' ]; then
#  #delete_web_server_logs 'N' "$PATH_WEB_LOG"
#  #delete_app_server_logs 'N' "$PATH_APP_LOG"
#  #delete_process_scheduler_logs 'N' "$PATH_PRCS_LOG"
#fi