#!/bin/bash

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# Fetch domains
echo $(psadmin -c list) > $SCRIPTPATH/domains_app
echo $(psadmin -p list) > $SCRIPTPATH/domains_prcs
echo $(psadmin -w list) > $SCRIPTPATH/domains_web