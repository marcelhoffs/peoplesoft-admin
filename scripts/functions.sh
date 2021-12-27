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
