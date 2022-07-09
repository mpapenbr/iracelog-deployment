# Install the helm charts

We need Helm (Version >= 3) installed on the local system. Follow the instructions from https://helm.sh/docs/intro/install

The helm charts used here require some dependencies. 
Execute the `prepare.sh` script to add the required helm repositories

The package is separated into two section: *iracelog* and *monitoring*. 
Whereas *iracelog* handles the core iracelog application the monitoring section is optional. 

Copy `local-values-sample.yml` to `local-values.yml` and adjust the properties for your needs.

## iracelog
The following command will install the iracelog application in the namespace *iracelog*
```console
helm upgrade --install iracelogapp ./iracelog-app --namespace iracelog --create-namespace -f local-values.yml
```
The application will create the following endpoints:
- `iracelog.<baseDomain>` contains the frontend
- `crossbar.<baseDomain>` contains the backend entry endpoint. 

## monitoring
The following command will install the monitoring for the iracelog application in the namespace *monitoring*

helm upgrade --install loki bitnami/grafana-loki --namespace monitoring --create-namespace -f local-values.yml

```console
helm upgrade --install monitoring ./monitoring --namespace monitoring --create-namespace -f local-values.yml
```

The application will create the following endpoints:
- `grafana.<baseDomain>` contains the grafana frontend

There a no other endpoints exposed. In case you need access you should follow best practise and create a port forward to the service.

For example:
use this to access the prometheus application via http://localhost:9090
```console
kubectl port-forward --namespace monitoring services/prometheus-operated 9090
```
### upgrading 

```console
helm upgrade monitoring ./monitoring --namespace monitoring  -f local-values.yml
```

### deleting
When deleting the namespace monitoring there may be some leftovers which need to be cleared before you can install the kube-prometheus-stack again.

check
```console
kubectl get validatingwebhookconfiguration -A
kubectl get mutatingwebhookconfiguration  -A
```
In our case we would have to delete
```console
kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io/monitoring-kube-prometheus-admission 
kubectl delete mutatingwebhookconfigurations.admissionregistration.k8s.io/monitoring-kube-prometheus-admission
```

See https://github.com/prometheus-community/helm-charts/issues/108#issuecomment-825689328 for details.

### Notes
There seems to be a problem with the node-exporter that may not start. Use
```console
kubectl patch ds monitoring-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]' -n monitoring
```
to fix the problem.
See https://stackoverflow.com/questions/70556984/kubernetes-node-exporter-container-is-not-working-it-shows-this-error-message


# Example: install on Google cloud

## Preparations
You should have an account to use the google cloud services.
You should have the google cloud console installed. See https://cloud.google.com/sdk/docs/install for instructions.

Note: When creating new projects the project has to be linked to a billing account. 
## Steps
```console
gcloud config set compute/zone europe-north1
gcloud config set compute/region europe-north1a

gcloud services enable container.googleapis.com
gcloud container clusters create iracelog-cluster --num-nodes=1
gcloud container clusters get-credentials iracelog-cluster

```

**Important #1:** Don't forget to delete the cluster when you don't need it any more.

```console
gcloud container clusters delete iracelog-cluster
```
**Important #2:** Don't forget to delete the persistent volume claim. 

Command pending, for now just check the project in the via 
https://console.cloud.google.com

Should be https://console.cloud.google.com/compute/disks