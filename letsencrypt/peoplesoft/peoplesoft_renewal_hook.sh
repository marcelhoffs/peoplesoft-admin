#!/bin/bash

# Variables
JAVABIN="<path to java bin>"
DOMAIN="<your domain>"
ALIAS="peoplesoft"
USER="psoft"
PSKEYSTORE="<absolute path to pskey location>"
CERTKEYSTORE="/etc/letsencrypt/live/"$DOMAIN"/"$ALIAS".pfx"
CERTPRIVKEY="/etc/letsencrypt/live/"$DOMAIN"/privkey.pem"
CERTSIGNED="/etc/letsencrypt/live/"$DOMAIN"/cert.pem"
CERTCHAIN="/etc/letsencrypt/live/"$DOMAIN"/chain.pem"
LEROOT="/etc/letsencrypt/live/"$DOMAIN"/le-root.pem"
LEINTERMEDIATE="/etc/letsencrypt/live/"$DOMAIN"/le-intermediate.pem"
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
  -alias le-root \
  -storepass $PASSWORD

  $JAVABIN/keytool -delete \
  -keystore $PSKEYSTORE \
  -alias le-intermediate \
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

# Download root and intermediate certificates for LetsEncrypt
curl https://letsencrypt.org/certs/isrg-root-x1-cross-signed.pem --output $LEROOT
curl https://letsencrypt.org/certs/lets-encrypt-r3.pem --output $LEINTERMEDIATE

# Import root chain
$JAVABIN/keytool \
-keystore $PSKEYSTORE \
-import \
-alias le-root \
-trustcacerts \
-file $LEROOT \
-storepass $PASSWORD \
-noprompt

# Import intermediate chain
$JAVABIN/keytool \
-keystore $PSKEYSTORE \
-import \
-alias le-intermediate \
-trustcacerts \
-file $LEINTERMEDIATE \
-storepass $PASSWORD \
-noprompt

# Restart PeopleSoft
# systemctl restart peoplesoft.service