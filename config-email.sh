#!/bin/bash

# check the arguments
if [ $# -lt 1 ]; then
  echo "How to use: $0 <youremail@gmail.com> [password|--ask]"
  exit 1
fi

GMAIL_USER="$1"

# --ask for interactive mode
if [ "$2" = "--ask" ]; then
  echo -n "Enter the password of $GMAIL_USER: "
  read -r -s -p "Enter Gmail password (or app password): " GMAIL_PASS
  echo
else
  GMAIL_PASS="$2"
fi

# clear the line of bash history
history -d $(history 1) 2>/dev/null

echo "Install Postfix and dependencies ..."
echo "===================================="
apt update
DEBIAN_FRONTEND=noninteractive apt install -y postfix mailutils mutt libsasl2-modules

echo "------------------------------------"
echo "Configurando Postfix para usar Gmail como relay..."
echo "=================================================="
tee /etc/postfix/sasl_passwd > /dev/null <<EOF
[smtp.gmail.com]:587 $GMAIL_USER:$GMAIL_PASS
EOF

chmod 600 /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

# Add a config file (If this not exist yet)
if ! grep -q "relayhost = \[smtp.gmail.com\]:587" /etc/postfix/main.cf; then
  tee -a /etc/postfix/main.cf > /dev/null <<EOF

# Configuration for Gmail
relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
EOF
fi

echo "---------------------------------------------------"
echo "Restart Postfix..."
echo "======================"
service postfix restart

echo "Configuration Complet."
echo "----------------------------"
