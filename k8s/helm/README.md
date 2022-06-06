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
helm install iracelogapp ./iracelog-app --namespace iracelog --create-namespace -f local-values.yml
```
The application will create the following endpoints:
- `iracelog.<baseDomain>` contains the frontend
- `crossbar.<baseDomain>` contains the backend entry endpoint. 

## monitoring
The following command will install the monitoring for the iracelog application in the namespace *monitoring*
```console
helm install monitoring ./monitoring --namespace monitoring --create-namespace -f local-values.yml
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

### Notes
There seems to be a problem with the node-exporter that may not start. Use
```console
kubectl patch ds monitoring-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]' -n monitoring
```
to fix the problem.
See https://stackoverflow.com/questions/70556984/kubernetes-node-exporter-container-is-not-working-it-shows-this-error-message

Some 