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
dns_cloudflare_api_token = IP8u9LEzu4EeFgP1O9Z6j9E4-5iKivaiNXkP96io
```

# Request a certificate
Execute the following command to request a certificate for your PeopleSoft environment through Let's Encrypt.
```
sudo certbot certonly \
--dns-cloudflare \
--dns-cloudflare-credentials ~/cloudflare.ini \
-d peoplesoft.example.com
```