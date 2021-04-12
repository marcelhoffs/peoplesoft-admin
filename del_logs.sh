#!/bin/bash

clear

# Fetch all domains
./domains.sh > /dev/null 2>&1

# Show Web Server log paths
< domains_web sed -n 1'p' | tr ',' '\n' | while read -r web; do
  echo -e "Application Server logs"
  echo -e "-----------------------"
  PATH_WEB_LOG_PIA="$web"": ""$PS_CFG_HOME""/webserv/""$web""/servers/PIA/logs"
  echo -e "$PATH_WEB_LOG_PIA"
done
