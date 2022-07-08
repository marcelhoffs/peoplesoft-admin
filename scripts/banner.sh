#!/bin/bash

# Constants
CYAN='\e[1;36m'
WHITE='\e[1;37m'
NC='\e[0m'

# Clear the screen
clear

# Show the banner
echo -e "${CYAN}"'========================================================'"${NC}"
echo -e "${WHITE}"'     ____                   __    _____       ______   '"${NC}"
echo -e "${WHITE}"'    / __ \___  ____  ____  / /__ / ___/____  / __/ /_  '"${NC}"
echo -e "${WHITE}"'   / /_/ / _ \/ __ \/ __ \/ / _ \\__ \/ __ \/ /_/ __/  '"${NC}"
echo -e "${WHITE}"'  / ____/  __/ /_/ / /_/ / /  __/__/ / /_/ / __/ /_    '"${NC}"
echo -e "${WHITE}"' /_/    \___/\____/ .___/_/\___/____/\____/_/  \__/    '"${NC}"
echo -e "${WHITE}"'                 /_/                                   '"${NC}"
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
echo -e "${CYAN}"'========================================================'"${NC}"
echo -e "${CYAN}"''"${NC}"