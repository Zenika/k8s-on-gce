#!/bin/sh

#destroy web firewall
gcloud -q compute firewall-rules delete \
  kubernetes-the-easy-way-allow-web || true

#terraform destroy 11-network
gcloud -q compute routes delete \
  kubernetes-route-10-200-0-0-24 \
  kubernetes-route-10-200-1-0-24 \
  kubernetes-route-10-200-2-0-24

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-easy-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(name)')
#terraform destroy -var "gce_ip_address=${KUBERNETES_PUBLIC_ADDRESS}" 08-kube-master

gcloud -q compute forwarding-rules delete --region europe-west1 kubernetes-forwarding-rule
gcloud -q compute target-pools delete kubernetes-target-pool

rm 07-etcd/*.retry

rm 06-encryption/encryption-config.yaml

rm 05-kubeconfig/*.kubeconfig

rm 04-certs/*.pem
rm 04-certs/*.csr

terraform destroy -var "gce_zone=${GCLOUD_ZONE}" -force 03-provisioning/
