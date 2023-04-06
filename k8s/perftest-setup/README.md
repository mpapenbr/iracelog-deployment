# Performance test setup

This document describes the setup for performance testing the iracelog app.
We use 3 kind clusters

| Type   | Description                              | Domain                |
| ------ | ---------------------------------------- | --------------------- |
| source | iracelog installation with events        | 127.0.0.1.nip.io:6767 |
| dest   | empty iracelog installation              | 127.0.0.1.nip.io:6768 |
| tester | contains racelogctl to perform the tests | 127.0.0.1.nip.io:6769 |

## create clusters

```console
for cluster in {source,dest,tester}; do kind create cluster -n $cluster --config cluster-config-$cluster.yml; done
```

## remove clusters

```console
for cluster in {source,dest,tester}; do kind delete cluster -n $cluster; done
```
