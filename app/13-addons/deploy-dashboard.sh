#!/bin/sh

kubectl apply -f kubernetes-dashboard.yml

DASHBOARD_TOKEN_SECRET=$(kubectl -n kube-system get secret | grep "dashboard-token" | awk '{ print $1 }')

DASHBOARD_TOKEN=$(kubectl -n kube-system describe secret $DASHBOARD_TOKEN_SECRET | grep token: | awk '{ print $2 }')

CONTAINER_ADDRESS=$(ip -4 -o addr show | grep eth0 | awk '{ print $4 }' | cut -d'/' -f 1)

echo "Launch kubectl proxy with the followind command:"
echo "kubectl proxy --address ${CONTAINER_ADDRESS}"
echo ""
echo "Then go to: http://localhost:8001/ui and sign in with the following token:"
echo "---"
echo $DASHBOARD_TOKEN
echo "---"
