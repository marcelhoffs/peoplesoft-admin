#!/bin/bash

# Variables
JAVABIN="<path to java bin>"
OS="<path to opensearch>"
OSD="<path to opensearch-dashboards>"
DOMAIN="<your domain>"
ALIAS="opensearch"
CERTKEYSTORE="/etc/letsencrypt/live/"$DOMAIN"/"$ALIAS".pfx"
CERTPRIVKEY="/etc/letsencrypt/live/"$DOMAIN"/privkey.pem"
CERTSIGNED="/etc/letsencrypt/live/"$DOMAIN"/cert.pem"
CERTCHAIN="/etc/letsencrypt/live/"$DOMAIN"/chain.pem"
PASSWORD="<password>"

# ---------------------------------------------------------------
# Generate keystore for OpenSearch
# ---------------------------------------------------------------

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

# Copy keystore for OpenSearch
cp $CERTKEYSTORE $OS/config

# ---------------------------------------------------------------
# Generate keystore for OpenSearch Dashboards
# ---------------------------------------------------------------

# Convert certificates and set permissions for OpenSearch Dashboards
openssl pkcs12 -in $CERTKEYSTORE -out $OSD/config/osd.pem -passin pass:$PASSWORD -passout pass:$PASSWORD
openssl rsa -in $OSD/config/osd.pem -out $OSD/config/osd.key -passin pass:$PASSWORD
cp $CERTSIGNED $OSD/config/osd.cer
chmod 644 $OSD/config/osd.key
rm $OSD/config/osd.pem

# Restart OpenSearch & OpenSearch Dashboards
systemctl restart opensearch.service
systemctl restart opensearch-dashboards.service