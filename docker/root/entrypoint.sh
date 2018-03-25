#!/usr/bin/env bash

mkdir -p /etc/ssl
envsubst '$DOMAIN_NAME $TARGET_URL' < /etc/nginx/nginx.conf.env > /etc/nginx/nginx.conf
nginx -g "daemon off;"
