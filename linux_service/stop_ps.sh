#!/bin/bash

# Source PeopleSoft Environment variables
source /home/psoft/psoft/dpk/pt/psft_env.sh
cd $PS_CFG_HOME

# Stop all Web Server domains
psadmin -w shutdown -d peoplesoft

# Stop all Application Server domains
psadmin -c shutdown -d APPDOM

# Stop all Process Scheduler domains
psadmin -p shutdown -d PRCSDOM