# iracelog-deployment (local)

Deployment configurations for local iracelog environments.
This environment should not be used in production as there are too many ports exposed.

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

The docker compose variant was tested on

- Ubuntu 20.04, Ubuntu 22.04 with
  - docker version 20.10 installed via PPA with docker compose plugin 2.14.1

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
