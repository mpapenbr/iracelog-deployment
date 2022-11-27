# iracelog-deployment (local)

Deployment configurations for local iracelog environments.
This environment should not be used in production as there are too many ports exposed.

There are also branches for _integration_ and _production_ which are used on iracing-tools.de

## Environment variables

You need to configure the following environment variables

| Key                          | Description                                                             |
| ---------------------------- | ----------------------------------------------------------------------- |
| POSTGRES_PASSWORD            | used to setup the Postgres database                                     |
| DB_USER_NAME                 | database user for iracelog                                              |
| DB_USER_PASSWORD             | the password for the database user                                      |
| CROSSBAR_DATAPROVIDER_TICKET | the credentials used by the racelogger to publish telemetry data        |
| CROSSBAR_BACKEND_TICKET      | the credentials used by the backend systems to communicate via crossbar |
| CROSSBAR_ADMIN_TICKET        | the credentials used by the admin CLI                                   |

The following environment variables are used to expose ports

| Key           | Description                  | Default |
| ------------- | ---------------------------- | ------- |
| DB_PORT       | Database port                | 5432    |
| CROSSBAR_PORT | Crossbar access port         | 8091    |
| IRACELOG_PORT | iRacelog frontend app        | 8092    |
| GRAPHQL_PORT  | GraphQL service for iRacelog | 8093    |

> **NOTE:**
> A simple way to create credentials on Linux systems is  
> $openssl rand --base64 15  
> u0qbWkaVb5KSfVHK5uxw

## Docker compose

Copy the `.env.sample` file to `.env ` and enter the credentials

Since we start with an empty database we need to create the tables before we can proceed.

On the very first start of the backend follow these steps:

```
docker compose up db-migrate
```

Once the database is initialized you can use the following command to start up the backend

```
docker compose up -d main-services
```

## Kubernetes

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

### Docker desktop with WSL

The files of the PV are located here:

```
\\wsl$\docker-desktop\mnt\version-pack\containers\services\docker\rootfs\
```

Consider this persistent volume definition:

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: iracelog-pv
  labels:
    type: local
spec:
  storageClassName: hostpath
  capacity:
    storage: 20Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/pv/data"
```

We use this PV for postgres, so the database files will be at

```
\\wsl$\docker-desktop\mnt\version-pack\containers\services\docker\rootfs\pv\data
```

**Note:** when deleting the PV the files will _NOT_ be deleted! This is by k8s design.

If for some reason the PV is not stored there (in such cases it may get a generic name like pvc-<some-uuid>) where the hostpath looks like `/var/lib/k8s-pvs/iracelog-db-claim/pvc-c7dde4ba-8ce6-4915-b1b2-874245b69dec` it is actually stored here:

```
\\wsl$\docker-desktop-data\version-pack-data\community\k8s-pvs\
```
