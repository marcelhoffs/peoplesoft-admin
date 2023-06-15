# Install certbot
Use the package manager to install certbot.
```
sudo dnf install certbot python3-certbot-dns-cloudflare
```

# Create a Cloudflare API token file
Request an API token at Cloudflare and store the token on the PeopleSoft server.
```
nano ~/cloudflare.ini
```
Then paste in the following content.
```
# Cloudflare API token used by Certbot
dns_cloudflare_api_token = <Cloudflare API token>
```

# Request a certificate
Execute the following command to request a certificate for your PeopleSoft environment through Let's Encrypt.
```
sudo certbot certonly \
--dns-cloudflare \
--dns-cloudflare-credentials ~/cloudflare.ini \
-d <your domain>
```

# Renewal post hook script
Modify the **peoplesoft_renewal_hook.sh** script. Adapt the variables DOMAIN, PSKEYSTORE and PASSWORD appropriately.
Copy the **peoplesoft_renewal_hook.sh** script to the following directory: **/etc/letsencrypt/renewal-hooks/post**
Set the script permissions:
```
sudo chmod 700 /etc/letsencrypt/renewal-hooks/post/peoplesoft_renewal_hook.sh
```

# Renew the certificate
Run the following command to renew the certificate and trigger the post hook script. This will get a new certificate and import this certificate into the peoplesoft keystore (pskey).
```
sudo certbot renew --force-renew
```