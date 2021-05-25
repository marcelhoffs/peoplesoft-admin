#!/bin/bash

# Source PeopleSoft Environment variables
source /home/psoft/psoft/dpk/pt/psft_env.sh
cd $PS_CFG_HOME

# Start all Application Server domains
psadmin -c start -d APPDOM

# Start all Web Server domains
psadmin -w start -d peoplesoft

# Start all Process Scheduler domains
psadmin -p start -d PRCSDOM