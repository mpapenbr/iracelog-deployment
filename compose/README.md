# Local docker compose setup

## Requirements

You need the following software installed on your server

- docker
- docker compose plugin (aka V2)

## iRacelog server

The iRacelog server runs via docker compose.

The following services need to be accesible from the outside.

- iracelog
- grpc
- graphql

In this sample their ports are just exposed using configurable ports. Keep in mind that this setup would use unsecured connections.

The default configuration is preconfiured for localhost and the default ports. In case you want to run it on different ports and/or host please adjust the configuration for the frontend in `config/iracelog/frontend.json`

```json
{
  "grpc": {
    "url": "http://localhost:8091"
  },
  "graphql": {
    "url": "http://localhost:8093/query"
  }
}
```

In production environments you surely want to use TLS for data exchange.

### Adjustments

This docker compose setup fits the needs in my personal environment. You may want to adjust the following:

- volume mount /var/local/dumps for service db
- importDump.sh is based on the above directory

### Initial steps

The database needs to be initialized with a credential that is used by the [racelogger].
This is done by creating an API key. For simple tests you may use the API key `test`

```shell
docker run --network=host --rm ghcr.io/mpapenbr/iracelog-cli:v0.7.0 -a localhost:8091 --insecure tenant edit --name default --api-key test --enable-active -t <ISM_ADMIN_TOKEN>

```

# Production setup

Have a look at the [ansible setup][ansible-setup]

---

[ansible-setup]: https://github.com/mpapenbr/iracelog-ansible-server-setup
[racelogger]: https://github.com/mpapenbr/go-racelogger
