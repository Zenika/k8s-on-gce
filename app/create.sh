#!/bin/sh

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

ansible-playbook -i inventory.cfg 08-kube-master/kube-master-playbook.yml
ansible-playbook -i inventory.cfg 08-kube-master/rbac-playbook.yml

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

#terraform apply 11-network
for instance in worker-0 worker-1 worker-2; do
  gcloud compute instances describe ${instance} \
    --format 'value[separator=" "](networkInterfaces[0].networkIP,metadata.items[0].value)'
done

for i in 0 1 2; do
  gcloud compute routes create kubernetes-route-10-200-${i}-0-24 \
    --network kubernetes-the-easy-way \
    --next-hop-address 10.240.0.2${i} \
    --destination-range 10.200.${i}.0/24
done

gcloud compute routes list --filter "network: kubernetes-the-easy-way"

./12-kubedns/setup-kubedns.sh