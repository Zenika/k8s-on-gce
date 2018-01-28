#!/bin/sh

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-easy-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

for instance in worker-0 worker-1 worker-2; do
  echo "Generating ${instance} config..."
  kubectl config set-cluster kubernetes-the-easy-way \
    --certificate-authority=../04-certs/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=../04-certs/${instance}.pem \
    --client-key=../04-certs/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-easy-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig

  if [ ! -f ${instance}.kubeconfig ]; then
    echo "Error creating ${instance} kube config"
    exit -1
  fi
done

echo "Generating kube-proxy config..."
kubectl config set-cluster kubernetes-the-easy-way \
  --certificate-authority=../04-certs/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials kube-proxy \
  --client-certificate=../04-certs/kube-proxy.pem \
  --client-key=../04-certs/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-easy-way \
  --user=kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

if [ ! -f kube-proxy.kubeconfig ]; then
    echo "Error creating kube-proxy kube config"
    exit -1
  fi