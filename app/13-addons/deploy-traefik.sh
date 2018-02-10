#!/bin/sh

kubectl apply -f traefik-rbac.yml
kubectl apply -f traefik-ds.yml

gcloud compute firewall-rules create kubernetes-the-easy-way-allow-web \
  --allow tcp:80,tcp:8080,tcp:8888 \
  --network kubernetes-the-easy-way \
  --source-ranges 0.0.0.0/0