#!/bin/sh
set -e

: "${DOMAIN_NAME:?DOMAIN_NAME is not set}"

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "[nginx] generating self-signed certificate for ${DOMAIN_NAME}"
    openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/CN=${DOMAIN_NAME}" \
        -addext "subjectAltName=DNS:${DOMAIN_NAME}"
    chmod 600 /etc/nginx/ssl/inception.key
fi

sed -i "s/DOMAIN_PLACEHOLDER/${DOMAIN_NAME}/" /etc/nginx/conf.d/inception.conf

nginx -t

echo "[nginx] starting nginx"
exec "$@"
