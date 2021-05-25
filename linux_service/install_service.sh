#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  # Not root
  echo 'Please run with root privileges:'
  echo 'sudo ./install_service.sh'
else
  # Copy scripts to /usr/bin
  cp start_ps.sh /usr/bin
  cp stop_ps.sh /usr/bin
  chown root:root /usr/bin/start_ps_sh
  chown root:root /usr/bin/stop_ps_sh
  chmod 755 /usr/bin/start_ps.sh
  chmod 755 /usr/bin/stop_ps.sh
  
  # Copy service to /etc/systemd/system
  cp peoplesoft.service /etc/systemd/system
  chown root:root /etc/systemd/system/peoplesoft.service
  chmod 755 /etc/systemd/system/peoplesoft.service
  
  # Enable service
  systemctl enable peoplesoft.service
fi