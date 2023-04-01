# Setup a local k8s cluster with kind

We will use _kind_ as the local kubernetes cluster. Follow these [instructions][kind-install]

## Preparations

### Create the cluster for iracelog tests

The cluster will use an ingress controller according to this [guide][kind-ingress]. The basic setup is defined in `cluster.config`

```console
kind create cluster --name iracelog --config cluster.config
```

Get the kubeconfig. This may be useful to add this cluster to OpenLens

```console
kind create cluster --name iracelog --config cluster.config
```

Deploy nginx ingress con

```console
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

Wait for the ingress to be ready

```console
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

Deploy demo

```console
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml
```

Check if all is running

```console
# should output "foo-app"
curl localhost/foo/hostname
# should output "bar-app"
curl localhost/bar/hostname
```

### Remove the cluster

```console
kind deleter cluster --name iracelog
```

---

[kind-install]: https://kind.sigs.k8s.io/docs/user/quick-start/
[kind-ingress]: https://kind.sigs.k8s.io/docs/user/ingress/
