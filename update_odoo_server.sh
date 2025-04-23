#!/bin/bash
if [ -f ./detect_rootless.sh ]; then
    source ./detect_rootless.sh
fi

./build_image.sh
docker stop odoo-server
docker rm odoo-server

# use command to create it:
#docker network create --attachable \
#--opt "com.docker.network.bridge.name=dockervpn0" \
#--opt "com.docker.network.bridge.enable_ip_masquerade=false" \
#dockervpn0
./run_odoo_server.sh
