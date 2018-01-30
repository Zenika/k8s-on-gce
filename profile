#!/bin/bash

source /root/google-cloud-sdk/completion.bash.inc
source /root/google-cloud-sdk/path.bash.inc

# For terraform
export GCLOUD_PROJECT=k8s-hw-1
export GCLOUD_REGION=europe-west1
export GCLOUD_ZONE=europe-west1-b

# For ansible
export GCE_PROJECT=$GCLOUD_PROJECT
export GCE_PEM_FILE_PATH=~/app/adc.json
export GCE_EMAIL=$(grep client_email $GCE_PEM_FILE_PATH | sed -e 's/  "client_email": "//g' -e 's/",//g')


# Setup gcloud
gcloud auth activate-service-account --key-file $GCE_PEM_FILE_PATH
gcloud config set project $GCLOUD_PROJECT
gcloud config set compute/region $GCLOUD_REGION
gcloud config set compute/zone $GCLOUD_ZONE