#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  # Not root
  echo 'Please run with root privileges:'
  echo 'sudo ./uninstall_service.sh'
else
  # Disable and remove service
  systemctl disable peoplesoft.service
  rm -f /etc/systemd/system/peoplesoft.service
  systemctl daemon-reload

  # Remove scripts
  rm -f /usr/bin/start_ps.sh
  rm -f /usr/bin/stop_ps.sh
fi