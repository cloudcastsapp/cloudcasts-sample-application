#!/usr/bin/env bash

# Stop supervisor jobs (if supervisor is used)
systemctl is-active --quiet supervisor && supervisorctl stop all

rm -rf /home/cloudcasts/cloudcasts.io