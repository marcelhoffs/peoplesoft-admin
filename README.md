Scripts
The scripts folder contains scripts to perform quick administrative tasks for PeopleSoft environments.
The following scripts are provided.

Script | Comment
--------- | ----
banner.sh | Displays a welcome banner
del_cache.sh | Deletes all cache files
del_logs.sh | Deletes all log files
functions.sh | Generic functions used by the other scripts
start_all.sh | Starts all PeopleSoft web, app and process domains on the server
stop_all.sh | Stops all PeopleSoft web, app and process domains on the server

# Systemd services
## Oracle Database
To enable the Oracle Database to startup on boot of the server, you can accomplish this with systemd.
You will have to edit the **oratab** file to set the correct paths.
First copy the **oratab** file to **/etc**

```
cp systemd/oratab /etc
```

You will have to edit the **oracledb.service** file to set the correct paths.
The copy the **oracledb.service** file to **/etc/systemd/system** and enable the service

```
cp systemd/oracledb.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable --now oracledb.service
```

## PeopleSoft PIA
To enable the PeopleSoft PIA to startup on boot of the server, you can accomplish this with systemd.
You will have to edit the **peoplesoft.service** file to set the correct paths.
Then copy the **peoplesoft.service** file to **/etc/systemd/system** and enable the service

```
cp systemd/peoplesoft.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable --now peoplesoft.service
```