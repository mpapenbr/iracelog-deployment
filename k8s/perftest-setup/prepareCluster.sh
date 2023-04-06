#!/bin/bash
CLUSTERS=({source,dest,tester})

for cluster in ${CLUSTERS[@]}
do
    echo Preparing cluster $cluster
    kubectl config set-cluster kind-$cluster 
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
done
echo Wait for nginx to be ready in clusters
for cluster in ${CLUSTERS[@]}
do
    echo Perparing cluster $cluster
    kubectl config set-cluster kind-$cluster 
    kubectl wait --namespace ingress-nginx  --for=condition=ready pod  --selector=app.kubernetes.io/component=controller  --timeout=90s
done