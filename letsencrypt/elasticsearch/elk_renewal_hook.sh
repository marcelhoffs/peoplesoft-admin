#!/bin/bash

# Variables
JAVABIN="/app/elk/pt/es_jdk11.0.18/bin"
DOMAIN="elk.corp.redboxconsulting.be"
ALIAS="elk"
ESKEYSTORE="/app/elk/pt/elasticsearch7.10.0/config/pskey"
CERTKEYSTORE="/etc/letsencrypt/live/"$DOMAIN"/"$ALIAS".pfx"
CERTPRIVKEY="/etc/letsencrypt/live/"$DOMAIN"/privkey.pem"
CERTSIGNED="/etc/letsencrypt/live/"$DOMAIN"/cert.pem"
PASSWORD="awrFQ8H1"

# Generate PKCS12 file for PeopleSoft
openssl pkcs12 \
-export \
-inkey $CERTPRIVKEY \
-in $CERTSIGNED \
-out $CERTKEYSTORE \
-name $ALIAS \
-password pass:$PASSWORD

# Change PKCS12 file permissions
chmod 755 $CERTKEYSTORE

# Delete existing certificate from peoplesoft keystore
$JAVABIN/keytool -delete \
-keystore $ESKEYSTORE \
-alias $ALIAS \
-storepass $PASSWORD

# Add certificate to keystore
$JAVABIN/keytool -importkeystore \
-destkeystore $ESKEYSTORE \
-deststorepass $PASSWORD \
-srckeystore $CERTKEYSTORE \
-srcstorepass $PASSWORD \
-srcstoretype PKCS12 \
-alias $ALIAS

# Copy certificate for Kibana
cp $ESKEYSTORE /app/elk/pt/Kibana7.10.0/config
cp $CERTSIGNED /app/elk/pt/Kibana7.10.0/config
chmod 644 *.pem

openssl pkcs12 -in /app/elk/pt/Kibana7.10.0/config/pskey -out /app/elk/pt/Kibana7.10.0/config/pskey.pem 
openssl rsa -in /app/elk/pt/Kibana7.10.0/config/pskey.pem -out /app/elk/pt/Kibana7.10.0/config/pskey.key

# Restart Elasticsearch
systemctl restart elasticsearch.service
systemctl restart kibana.service