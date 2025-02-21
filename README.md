# iracelog-deployment (local)

Deployment configurations for local iracelog environments.
This environment should not be used in production as there are too many ports exposed.

## Docker compose

See [this guide](compose/README.md) for details.

## Kubernetes

### Helm

See [this guide](k8s/helm/README.md) for details.

### Kustomize

_Deprecation notice_: This variant is no longer maintained. It may or may not work. It was replaced by the helm variant.

The base directory for all following commands is `k8s/kustomize`.

```
cd k8s/kustomize
```

Since we start with an empty database we need to create the tables before we can proceed.

On the very first start of the backend follow these steps:

```
kubectl apply -k mig
kubectl apply -k common
```

Later, a normal startup can be used by

```
kubectl apply -k db
kubectl apply -k common
```

To remove the application, but leave the database running:

```
kubectl delete -k common
```

### export database

```
kubectl -n iracelog exec -i postgres-0 -- pg_dump  -U docker --role=docker -d iracelog -Fc > dumpfile.dat
```

### import database

```
kubectl -n iracelog exec -i postgres-0 -- pg_restore  -U docker --role=docker -d iracelog < dumpfile.dat
```

**Note:** you will need to adjust the memory limits for the postgres service while importing dumps. It turns out Postgres uses a lot of memory when doing _pg_restore_.
(Importing the iracelog-20211129.dump with 800M needs about 6GB memory to get the work done).
The following cound work:

- remove memory limit from service
- apply config
- import dump
- reset memory limit
