#!/bin/bash

# Disable and remove service
systemctl disable peoplesoft.service
rm -f /etc/systemd/system/peoplesoft.service

# Remove scripts
rm -f /usr/bin/start_ps.sh
rm -f /usr/bin/stop_ps.sh