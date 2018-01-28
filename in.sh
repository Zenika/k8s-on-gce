#!/bin/sh

docker build . -t terra

if [[ $? -eq 0 ]]; then
    docker rm -f terra 
    
    docker run -it \
        -v $PWD/../tools/gcloud:/root/.config/gcloud \
        -v $PWD/app:/root/app \
        --name terra terra
fi