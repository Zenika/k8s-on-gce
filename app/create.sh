#!/bin/sh

export ETCD_VERSION=v3.3.5
export CNI_VERSION=0.3.1
export CNI_PLUGINS_VERSION=v0.6.0
export CONTAINERD_VERSION=1.2.0-rc.0

rm -f /root/.ssh/google_compute_engine*
# ⚠️ Here we create a key with no passphrase
ssh-keygen -q -P "" -f /root/.ssh/google_compute_engine

terraform init 03-provisioning

terraform apply -auto-approve -var "gce_zone=${GCLOUD_ZONE}" 03-provisioning

cd /root/app/04-certs
./gen-certs.sh

cd /root/app/05-kubeconfig
./gen-conf.sh

cd /root/app/06-encryption
./gen-encrypt.sh

cd /root/app
00-ansible/create-inventory.sh

ansible-playbook -i inventory.cfg 07-etcd/etcd-playbook.yml

ansible-playbook -i inventory.cfg 08-kube-controller/kube-controller-playbook.yml
ansible-playbook -i inventory.cfg 08-kube-controller/rbac-playbook.yml

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-easy-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(name)')
  
#terraform create -var "gce_ip_address=${KUBERNETES_PUBLIC_ADDRESS}" 08-kube-master
gcloud compute target-pools create kubernetes-target-pool

gcloud compute target-pools add-instances kubernetes-target-pool \
  --instances controller-0,controller-1,controller-2

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-easy-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

gcloud compute forwarding-rules create kubernetes-forwarding-rule \
  --address ${KUBERNETES_PUBLIC_ADDRESS} \
  --ports 6443 \
  --region $(gcloud config get-value compute/region) \
  --target-pool kubernetes-target-pool

ansible-playbook -i inventory.cfg 09-kubelet/kubelet-playbook.yml

./10-kubectl/setup-kubectl.sh

./11-network/network-conf.sh

./12-kubedns/setup-kubedns.sh
