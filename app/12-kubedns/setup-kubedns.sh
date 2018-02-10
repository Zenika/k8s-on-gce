#!/bin/sh

kubectl create -f 12-kubedns/kube-dns.yml

kubectl get pods -l k8s-app=kube-dns -n kube-system