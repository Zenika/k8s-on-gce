#!/bin/sh

docker build . -t tools

if [[ $? -eq 0 ]]; then
    docker rm -f tools 
    
    docker run -it \
        -v $PWD/app:/root/app \
        -p 8001:8001 \
        --name tools tools
fi