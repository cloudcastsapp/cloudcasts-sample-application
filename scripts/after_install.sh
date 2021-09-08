#!/usr/bin/env bash

chown -R cloudcasts:cloudcasts /home/cloudcasts/cloudcasts.io

cd /home/cloudcasts/cloudcasts.io
aws --region us-east-2 ssm get-parameter \
    --with-decryption \
    --name /cloudcasts/staging/env \
    --output text \
    --query 'Parameter.Value' > .env

chown cloudcasts:cloudcasts /home/cloudcasts/cloudcasts.io/.env

service php8.0-fpm reload