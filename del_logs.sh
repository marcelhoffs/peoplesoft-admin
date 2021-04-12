#!/bin/bash

clear

# Fetch all domains
./domains.sh > /dev/null 2>&1

# Show Web Server log paths
echo -e "Web Server logs"
echo -e "---------------"
< domains_web sed -n 1'p' | tr ',' '\n' | while read -r web; do
  PATH_WEB_LOG="$web"": ""$PS_CFG_HOME""/webserv/""$web""/servers/PIA/logs"
  echo -e "$PATH_WEB_LOG"
done

# Show Application Server log paths
echo ''
echo -e "Application Server logs"
echo -e "-----------------------"
< domains_app sed -n 1'p' | tr ',' '\n' | while read -r app; do
  PATH_APP_LOG="$app"": ""$PS_CFG_HOME""/appserv/""$app""/LOGS"
  echo -e "$PATH_APP_LOG"
done

# Show Process Scheduler log paths
echo ''
echo -e "Process Scheduler logs"
echo -e "----------------------"
< domains_prcs sed -n 1'p' | tr ',' '\n' | while read -r prcs; do
  PATH_PRCS_LOG="$prcs"": ""$PS_CFG_HOME""/appserv/prcs/""$prcs""/LOGS"
  echo -e "$PATH_PRCS_LOG"
done
