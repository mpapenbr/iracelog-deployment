# iracelog-deployment (local)
Deployment configurations for local iracelog environments.
This environment should not be used in production as there are too many ports exposed. 

There are also branches for *integration* and *production* which are used on iracing-tools.de

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

