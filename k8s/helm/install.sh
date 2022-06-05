helm repo add traefik https://helm.traefik.io/traefik
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create namespace iracelog
helm dependency build ./iracelog-app 
helm install iracelogapp ./iracelog-app --namespace iracelog