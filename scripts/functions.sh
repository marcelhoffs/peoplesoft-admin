#!/bin/bash

# Constants
IFS=','

# ================================================================
# FUNCTIONS
# ================================================================

get_domains() {
  # Get PeopleSoft domains
  APPDOMAINS=$(psadmin -c list 2>/dev/null)
  PRCSDOMAINS=$(psadmin -p list 2>/dev/null)
  WEBDOMAINS=$(psadmin -w list 2>/dev/null)

  # Put domains in array
  read -a ARR_APP <<<"$APPDOMAINS"
  read -a ARR_PRCS <<<"$PRCSDOMAINS"
  read -a ARR_WEB <<<"$WEBDOMAINS"
}

# ----------------------------------------------------------------

get_domain_base_paths() {
  # Determine Web Server log paths
  for i in "${!ARR_WEB[@]}"; do
    ARR_WEB_BASE[$i]="${PS_CFG_HOME}/webserv/${ARR_WEB[$i]}"
  done

  # Determine Application Server log paths
  for i in "${!ARR_APP[@]}"; do
    ARR_APP_BASE[$i]="${PS_CFG_HOME}/appserv/${ARR_APP[$i]}"
  done

  # Determine Process Scheduler log paths
  for i in "${!ARR_PRCS[@]}"; do
    ARR_PRCS_BASE[$i]="${PS_CFG_HOME}/appserv/prcs/${ARR_PRCS[$i]}"
  done
}

# ----------------------------------------------------------------

get_environment() {
  # Absolute path to this script
  SCRIPT=$(readlink -f "$0")
  SCRIPTPATH=$(dirname "$SCRIPT")

  # Source if needed
  if [ "x$IS_PS_PLT" != "xY" ]; then
    source $SCRIPTPATH/psft_env.sh
  fi
}

# ----------------------------------------------------------------