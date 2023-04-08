#!/bin/bash

CLUSTERS=({source,dest})

# path to local helm charts
HELMCHART_DIR=../../helm

for cluster in ${CLUSTERS[@]}
do
    echo Preparing ingress for cluster $cluster    
    kubectl --kubeconfig=$HOME/.kube/$cluster.kubeconfig apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
done

echo Deploying software into clusters
for cluster in ${CLUSTERS[@]}
do
    echo Preparing cluster $cluster    
    echo Wait for ingress
    kubectl --kubeconfig=$HOME/.kube/$cluster.kubeconfig wait --namespace ingress-nginx  --for=condition=ready pod  --selector=app.kubernetes.io/component=controller  --timeout=90s
    echo Install monitoring
    helm --kubeconfig $HOME/.kube/$cluster.kubeconfig upgrade --install monitoring $HELMCHART_DIR/monitoring --namespace monitoring --create-namespace -f local-values.yml -f local-$cluster.yml
    echo Install iracelog
    helm --kubeconfig $HOME/.kube/$cluster.kubeconfig upgrade --install iracelogapp $HELMCHART_DIR/iracelog-app --namespace iracelog --create-namespace -f local-values.yml -f local-$cluster.yml
done