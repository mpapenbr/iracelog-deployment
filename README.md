# iracelog-deployment
Deployment configurations for iracelog

## Environment variables

You need to configure the following environment variables

|Key|Description|
|---|-----------|
|POSTGRES_PASSWORD| used to setup the Postgres database|
|DB_USER_NAME|database user for iracelog|
|DB_USER_PASSWORD|the password for the database user|
|CROSSBAR_DATAPROVIDER_TICKET|the credentials used by the racelogger to publish telemetry data|
|CROSSBAR_BACKEND_TICKET|the credentials used by the backend systems to communicate via crossbar|
|CROSSBAR_ADMIN_TICKET|the credentials used by the admin CLI|


>**NOTE:**
A simple way to create credentials on Linux systems is  
$openssl rand --base64 15  
u0qbWkaVb5KSfVHK5uxw

## Docker compose

Copy the `.env.sample` file to `.env ` and enter the credentials 

Since we start with an empty database we need to create the tables before we can proceed. This is done by `migratedb.sh`

On the very first start of the backend follow these steps:
- docker compose up -d db 
- ./migratedb.sh
- docker compose up -d 

Later you can just start the backend by executing 
```
docker compose up -d
```
## Kubernetes

