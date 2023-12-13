#!/bin/bash

# Variables
JAVABIN="<path to java bin>"
DOMAIN="<your domain>"
ALIAS="elk"
CERTKEYSTORE="/etc/letsencrypt/live/"$DOMAIN"/"$ALIAS".pfx"
CERTPRIVKEY="/etc/letsencrypt/live/"$DOMAIN"/privkey.pem"
CERTSIGNED="/etc/letsencrypt/live/"$DOMAIN"/cert.pem"
CERTCHAIN="/etc/letsencrypt/live/"$DOMAIN"/chain.pem"
PASSWORD="awrFQ8H1"

# Generate PKCS12 file for PeopleSoft
openssl pkcs12 \
-export \
-inkey $CERTPRIVKEY \
-in $CERTSIGNED \
-out $CERTKEYSTORE \
-name $ALIAS \
-password pass:$PASSWORD

# Import root/intermediate chain
$JAVABIN/keytool \
-keystore $CERTKEYSTORE \
-import \
-alias rootintermediate \
-trustcacerts \
-file $CERTCHAIN \
-storepass $PASSWORD

# Change PKCS12 file permissions
chmod 755 $CERTKEYSTORE

# Copy keystore for Elasticsearch
cp $CERTKEYSTORE /app/elk/pt/elasticsearch7.10.0/config

# Copy certificate for Kibana
cp $CERTKEYSTORE /app/elk/pt/Kibana7.10.0/config
cp $CERTSIGNED /app/elk/pt/Kibana7.10.0/config
chmod 644 *.pem

openssl pkcs12 -in /app/elk/pt/Kibana7.10.0/config/pskey -out /app/elk/pt/Kibana7.10.0/config/pskey.pem 
openssl rsa -in /app/elk/pt/Kibana7.10.0/config/pskey.pem -out /app/elk/pt/Kibana7.10.0/config/pskey.key

# Restart Elasticsearch & Kibana
systemctl restart elasticsearch.service
systemctl restart kibana.service