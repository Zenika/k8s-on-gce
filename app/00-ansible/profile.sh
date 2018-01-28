#!/bin/bash
export GCE_PROJECT=k8s-hw-1
export GCE_PEM_FILE_PATH=~/app/adc.json
export GCE_EMAIL=$(grep client_email $GCE_PEM_FILE_PATH | sed -e 's/  "client_email": "//g' -e 's/",//g')
gcloud config set project $GCE_PROJECT
