#!/bin/bash

clear

# Fetch all domains
./domains.sh > /dev/null 2>&1

# Show Application Server log paths
< domains_web sed -n 1'p' | tr ',' '\n' | while read -r web; do
  echo -e "Application Server logs"
  echo -e "-----------------------"
  echo -e "$web"": " $PS_CFG_HOME
done