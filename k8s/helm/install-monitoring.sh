helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring
# workaround to get node-exporter running on docker-desktop ()
# https://stackoverflow.com/questions/70556984/kubernetes-node-exporter-container-is-not-working-it-shows-this-error-message
# execute this manually
# kubectl patch ds monitoring-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'