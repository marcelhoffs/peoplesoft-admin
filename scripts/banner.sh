#!/bin/bash

# Constants
CYAN='\e[1;36m'
WHITE='\e[1;37m'
NC='\e[0m'

# Clear the screen
clear

# Show the banner
echo -e "${CYAN}"'======================================================'"${NC}"
echo -e "${WHITE}"'  _____                 _       _____        __ _    '"${NC}"
echo -e "${WHITE}"' |  __ \               | |     / ____|      / _| |   '"${NC}"
echo -e "${WHITE}"' | |__) |__  ___  _ __ | | ___| (___   ___ | |_| |_  '"${NC}"
echo -e "${WHITE}"' |  ___/ _ \/ _ \|  _ \| |/ _ \\___ \ / _ \|  _| __| '"${NC}"
echo -e "${WHITE}"' | |  |  __/ (_) | |_) | |  __/____) | (_) | | | |_  '"${NC}"
echo -e "${WHITE}"' |_|   \___|\___/| .__/|_|\___|_____/ \___/|_|  \__| '"${NC}"
echo -e "${WHITE}"'                 | |                                 '"${NC}"
echo -e "${WHITE}"'                 |_|                                 '"${NC}"
echo -e "${CYAN}"' '"$(psadmin -v)""${NC}"
echo -e "${CYAN}"''"${NC}"
echo -e "${CYAN}"' PS_HOME     : '"${WHITE}""$PS_HOME""${NC}"
echo -e "${CYAN}"' PS_APP_HOME : '"${WHITE}""$PS_APP_HOME""${NC}"
echo -e "${CYAN}"' PS_CFG_HOME : '"${WHITE}""$PS_CFG_HOME""${NC}"
echo -e "${CYAN}"' PS_CUST_HOME: '"${WHITE}""$PS_CUST_HOME""${NC}"
echo -e "${CYAN}"''"${NC}"
echo -e "${CYAN}"' COMMANDS:'"${NC}"
echo -e "${CYAN}"' ---------'"${NC}"
echo -e "${CYAN}"' Start all domains: '"${WHITE}"'start_all.sh'"${NC}"
echo -e "${CYAN}"' Stop all domains : '"${WHITE}"'stop_all.sh'"${NC}"
echo -e "${CYAN}"' Clear cache      : '"${WHITE}"'del_cache.sh'"${NC}"
echo -e "${CYAN}"' Delete logs      : '"${WHITE}"'del_logs.sh'"${NC}"
echo -e "${CYAN}"' PeopleSoft Admin : '"${WHITE}"'psadmin'"${NC}"
echo -e "${CYAN}"''"${NC}"
echo -e "${CYAN}"'======================================================'"${NC}"
echo -e "${CYAN}"''"${NC}"