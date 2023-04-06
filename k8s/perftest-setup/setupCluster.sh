#!/bin/bash

for cluster in {source,dest,tester}
do
    echo Creating cluster $cluster
    kind create cluster -n $cluster --config cluster-config-$cluster.yml
    # kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
done