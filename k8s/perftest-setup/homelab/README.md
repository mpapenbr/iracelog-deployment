# Performance test setup

This document describes the setup for performance testing the iracelog app with kind clusters.

We use 3 virtual machines, each containing a kind cluster configured with the following setup.

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "192.168.178.3x"
  apiServerPort: 6443
nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
        protocol: TCP
      - containerPort: 443
        hostPort: 443
        protocol: TCP
  - role: worker
  - role: worker
```

The setup of the virtual machines including the installation of the required software and creating the cluster is not part of this document. The kubeconfigs of the clusters are stored in the users directory `~/.kube`

kind clusters

| Type   | Description                       | Domain  | .kubeconfig               |
| ------ | --------------------------------- | ------- | ------------------------- |
| source | iracelog installation with events | ubtest5 | ~/.kube/source.kubeconfig |
| dest   | empty iracelog installation       | ubtest6 | ~/.kube/dest.kubeconfig   |

Initialize the cluster with the following script. This will setup an nginx ingress, install monitoring and iraclog into each cluster

```console
./prepareCluster.sh
```

## Performance test

Performance test is done by using the CLI tool [racelogctl]. The _stress_ commands of this tool can simulate data providers and browser clients.

Copy the `.env.homelab` to `.env` and adjust the values according to the setup used for the cluster.

---

[racelogctl]: http://github.com/mpapenbr/racelogctl
