#!/bin/bash
CACHE_OPTS=""
if [ -e use_cache ]; then
    echo "WARN: caching enabled"
else
    CACHE_OPTS="--no-cache"
    # always pull
    #CACHE_OPTS="--pull ${CACHE_OPTS}"
fi

if [ -f ./detect_rootless.sh ]; then
    source ./detect_rootless.sh
fi

# export BUILDKIT_PROGRESS=plain
docker build ${CACHE_OPTS} --network=host -t odoo_server .

ret_code=$?
if [ $ret_code == 0 ]; then
    echo "Build succeeded"
else
    echo "Build failed"
    # make sure base image is built
    TARGET=$(grep -e FROM Dockerfile | awk '{print($2);}')
    echo "#-------------------------------------------------"
    echo "# make sure base image is built:"
    echo "# ${TARGET}"
    echo "#-------------------------------------------------"
    docker image ls ${TARGET}
fi

