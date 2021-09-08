#!/usr/bin/env bash

# Generate .env
cd /home/cloudcasts/cloudcasts.io
aws --region us-east-2 ssm get-parameter \
    --with-decryption \
    --name /cloudcasts/staging/env \
    --output text \
    --query 'Parameter.Value' > .env

# Set permissions
chown -R cloudcasts:cloudcasts /home/cloudcasts/cloudcasts.io

# Reload php-fpm (clear opcache) if running
systemctl is-active --quiet php8.0-fpm && service php8.0-fpm reload

# Start supervisor jobs (if supervisor is used)
systemctl is-active --quiet supervisor && supervisorctl start all