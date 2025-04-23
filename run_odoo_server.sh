#!/bin/bash
if [ -f ./detect_rootless.sh ]; then
    source ./detect_rootless.sh
fi

# for dma
MAIL_CONFIG="-v /etc/dma:/etc/dma:ro"
MAIL_CONFIG="${MAIL_CONFIG} -v /etc/aliases:/etc/aliases:ro"

# --restart=unless-stopped
# --memory=1500m --memory-swappiness=0

#odoo ports
# odoo server
PORTS="${PORTS} -p 127.0.0.1:8069:8069"
# odoo chat
PORTS="${PORTS} -p 127.0.0.1:8072:8072"

# for reverse proxy see
# https://www.odoo.com/documentation/master/administration/on_premise/deploy.html#https

# mounts
MOUNTS="-v /srv/odoo:/srv/odoo"
# disable mounts
MOUNTS=""

# with docker-net
docker run --init -d --name="odoo-server" \
       --restart=unless-stopped \
       ${MOUNTS} \
       ${PORTS} \
       --net=docker-net \
       --hostname=odoo \
       odoo_server:latest

echo 'connect to odoo-server'
echo 'http://localhost:8069'
echo 'http://localhost:8072'