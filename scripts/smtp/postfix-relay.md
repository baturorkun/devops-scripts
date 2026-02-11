
https://www.linode.com/docs/guides/configure-postfix-to-send-mail-using-gmail-and-google-workspace-on-debian-or-ubuntu/



sudo apt-get install libsasl2-modules postfix

vi /etc/postfix/sasl/sasl_passwd

Added:

[smtp.gmail.com]:587 username@gmail.com:password

postmap /etc/postfix/sasl/sasl_passwd

sudo chown root:root /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db
sudo chmod 0600 /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db

vi /etc/postfix/main.cf

Changed:
relayhost = [smtp.gmail.com]:587


Added:

# Enable SASL authentication
smtp_sasl_auth_enable = yes
# Disallow methods that allow anonymous authentication
smtp_sasl_security_options = noanonymous
# Location of sasl_passwd
smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
# Enable STARTTLS encryption
smtp_tls_security_level = encrypt
# Location of CA certificates
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt



sudo systemctl restart postfix


Test Postfix Email Sending With Gmail
Use Postfix’s sendmail implementation to send a test email. Enter lines similar to those shown below, and note that there is no prompt between lines until the . ends the process:

sendmail recipient@elsewhere.com
From: you@example.com
Subject: Test mail
This is a test email
.