# Local docker compose setup

## Requirements

You need the following software installed on your server

- docker
- docker compose plugin (aka V2)
  The old variant docker-compose (aka V1) should also work, but there may be issues.

## iRacelog server

The iRacelog server runs via docker compose.

The following services need to be accesible from the outside.

- iracelog
- crossbar
- graphql

In this sample their ports are just exposed using configurable ports. Keep in mind that this setup would use unsecured connections.

The default configuration is preconfiured for localhost and the default ports. In case you want to run it on different ports and/or host please adjust the configuration for the frontend in `config/iracelog/frontend.json`

```json
{
  "crossbar": {
    "url": "ws://localhost:8091",
    "realm": "racelog"
  },
  "graphql": {
    "url": "http://localhost:8093/query"
  }
}
```

In production environments you surely want to use TLS for data exchange.

# Production setup

Have a look at the [ansible setup](https://github.com/mpapenbr/iracelog-ansible-server-setup)
