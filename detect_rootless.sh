#!/bin/bash

DOCKER=$(which docker)
if [ "$DOCKER" == "$HOME/bin/docker" ];then
    echo "docker rootless detected: $HOME/bin/docker"
elif [ "$DOCKER" == "$HOME/.local/bin/docker" ];then
    echo "docker rootless detected: $HOME/.local/bin/docker"
else
    if [ "$(groups | grep docker)" == "" ]; then
        echo "create alias for docker to use sudo"
        alias docker="sudo $(which docker)"
        shopt -s expand_aliases
    else
        echo "user is in the docker group"
    fi
fi
