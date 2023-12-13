#!/bin/bash

# Variables
JAVABIN="<path to java bin>"
DOMAIN="<your domain>"
ALIAS="peoplesoft"
ALIASROOT="le-rootinter"
USER="psoft"
PSKEYSTORE="<absolute path to pskey location>"
CERTKEYSTORE="/etc/letsencrypt/live/"$DOMAIN"/"$ALIAS".pfx"
CERTPRIVKEY="/etc/letsencrypt/live/"$DOMAIN"/privkey.pem"
CERTSIGNED="/etc/letsencrypt/live/"$DOMAIN"/cert.pem"
CERTCHAIN="/etc/letsencrypt/live/"$DOMAIN"/chain.pem"
PASSWORD="<password>"

# ---------------------------------------------------------------
# Generate keystore for PeopleSoft
# ---------------------------------------------------------------

# Generate PKCS12 file for PeopleSoft
openssl pkcs12 \
-export \
-inkey $CERTPRIVKEY \
-in $CERTSIGNED \
-out $CERTKEYSTORE \
-name $ALIAS \
-password pass:$PASSWORD

# Change PKCS12 file permissions
chmod 750 $CERTKEYSTORE

# Check if keystore already exists
if test -f $PSKEYSTORE; then
  # Delete existing certificates from PeopleSoft keystore
  $JAVABIN/keytool -delete \
  -keystore $PSKEYSTORE \
  -alias $ALIASROOT \
  -storepass $PASSWORD

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
else
  # Copy keystore to WebLogic domain
  cp $CERTKEYSTORE $PSKEYSTORE
  chown $USER:$USER $PSKEYSTORE
fi

# Import root/intermediate chain
$JAVABIN/keytool \
-keystore $PSKEYSTORE \
-import \
-alias $ALIASROOT \
-trustcacerts \
-file $CERTCHAIN \
-storepass $PASSWORD

# Restart PeopleSoft
systemctl restart peoplesoft.service