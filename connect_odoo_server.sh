#!/bin/bash
if [ -f ./detect_rootless.sh ]; then
    source ./detect_rootless.sh
fi

if [ "$#" -eq 0 ];then
    docker exec -ti odoo-server bash
else
    docker exec -ti odoo-server "$@"
fi
