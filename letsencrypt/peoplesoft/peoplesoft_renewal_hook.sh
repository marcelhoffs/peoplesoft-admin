#!/bin/bash

# Variables
JAVABIN="<path to java bin>"
DOMAIN="<your domain>"
ALIAS="peoplesoft"
PSKEYSTORE="<absolute path to pskey location>"
CERTKEYSTORE="/etc/letsencrypt/live/"$DOMAIN"/"$ALIAS".pfx"
CERTPRIVKEY="/etc/letsencrypt/live/"$DOMAIN"/privkey.pem"
CERTSIGNED="/etc/letsencrypt/live/"$DOMAIN"/cert.pem"
PASSWORD="<your pskey password>"

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
-keystore $PSKEYSTORE \
-alias $ALIAS \
-storepass $PASSWORD

# Add certificate to keystore
$JAVABIN/keytool -importkeystore \
-destkeystore $PSKEYSTORE \
-deststorepass $PASSWORD \
-srckeystore $CERTKEYSTORE \
-srcstorepass $PASSWORD \
-srcstoretype PKCS12 \
-alias $ALIAS

# Restart PeopleSoft
systemctl restart peoplesoft.service