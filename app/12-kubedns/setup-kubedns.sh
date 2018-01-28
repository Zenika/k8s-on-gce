#!/bin/sh

kubectl create -f https://storage.googleapis.com/kubernetes-the-hard-way/kube-dns.yaml

kubectl get pods -l k8s-app=kube-dns -n kube-system