#!/bin/bash

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# ================================================================
# FUNCTIONS
# ================================================================

delete_web_server_cache() {
  TEST=$1
  ARG1=$2

  # Get sites for this web domain from piaInstallLog.xml
  PIA_INSTALL_LOG="${ARG1:?}/piaconfig/properties/piaInstallLog.xml"
  CMD_PIA_SITES=$(sed -ne 's/.*Site name="\([^"]*\).*/\1/p' "$PIA_INSTALL_LOG")
  read -a PIA_SITES <<<"$CMD_PIA_SITES"

  for i in "${!PIA_SITES[@]}"; do
    CMD1_ARG="${ARG1:?}/applications/peoplesoft/PORTAL.war/${PIA_SITES[$i]}/cache/*"

    if [ "$TEST" = 'Y' ]; then
      echo "$CMD1_ARG"
    else
      rm -r $CMD1_ARG
    fi
  done
}

# ----------------------------------------------------------------

delete_app_server_cache() {
  TEST=$1
  ARG1=$2

  CMD1_ARG="${ARG1:?}/CACHE/*"

  if [ "$TEST" = 'Y' ]; then
    # Show path
    echo "$CMD1_ARG"
  else
    # Delete
    rm -r $CMD1_ARG
  fi
}

# ----------------------------------------------------------------

delete_process_scheduler_cache() {
  TEST=$1
  ARG1=$2

  CMD1_ARG="${ARG1:?}/CACHE/*"

  if [ "$TEST" = 'Y' ]; then
    # Show path
    echo "$CMD1_ARG"
  else
    # Delete
    rm -r $CMD1_ARG
  fi
}

# ----------------------------------------------------------------

delete_cache() {
  TEST=$1

  # Web Server
  for i in "${!ARR_WEB_BASE[@]}"; do
    if [ "$TEST" = 'Y' ] && [ $i = 0 ]; then
      echo ''
      echo -e "Web server cache"
      echo -e "----------------"
    fi
    delete_web_server_cache "$TEST" "${ARR_WEB_BASE[$i]}"
  done

  # Application Server
  for i in "${!ARR_APP_BASE[@]}"; do
    if [ "$TEST" = 'Y' ] && [ $i = 0 ]; then
      echo ''
      echo -e "Application server cache"
      echo -e "------------------------"
    fi
    delete_app_server_cache "$TEST" "${ARR_APP_BASE[$i]}"
  done

  # Process Scheduler
  for i in "${!ARR_PRCS_BASE[@]}"; do
    if [ "$TEST" = 'Y' ] && [ $i = 0 ]; then
      echo ''
      echo -e "Process Scheduler cache"
      echo -e "-----------------------"
    fi
    delete_process_scheduler_cache "$TEST" "${ARR_PRCS_BASE[$i]}"
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

# Fetch all domains and base paths
source $SCRIPTPATH/functions.sh
get_domains
get_domain_base_paths

# TEST mode, just to show the paths that will be deleted
delete_cache 'Y'

echo ''
echo -e "--------------------------------------------------------------"
echo ''

# Ask to continue
while [ "$CONTINUE" != 'Y' ] && [ "$CONTINUE" != 'N' ]; do
  read -r -p 'Are you sure you want to continue? [Y/N]: ' CONTINUE
  CONTINUE=${CONTINUE^^}
done

# Delete cache
if [ "$CONTINUE" = 'Y' ]; then
  # Delete cache (no TEST mode)
  delete_cache 'N'
fi
