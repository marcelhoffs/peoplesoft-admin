#!/bin/bash

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

  for i in "${!arrwebbase[@]}"
  do
    delete_web_server_cache "$test" "${arrwebbase[$i]}"
  done

  # Application Server
  if [ "$test" = 'Y' ]; then
    echo -e "Application server cache"
    echo -e "------------------------"
  fi

  for i in "${!arrappbase[@]}"
  do
    delete_app_server_cache "$test" "${arrappbase[$i]}"
  done

  # Process Scheduler
  if [ "$test" = 'Y' ]; then
    echo -e "Process Scheduler cache"
    echo -e "-----------------------"
  fi

  for i in "${!arrprcsbase[@]}"
  do
    delete_process_scheduler_cache "$test" "${arrprcsbase[$i]}"
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
source ./functions.sh
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