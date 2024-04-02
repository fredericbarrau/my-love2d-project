# Deployment as a K8S operator

This application will be deployed as a kubernetes application. This folder contains the necessary files to deploy the application, as well as all the elements needed to setup a development environment.

Ready ? Let's go !

## Prerequisites

- [Docker](https://www.docker.com/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) or any other kubernetes cluster
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- [golang](https://golang.org/doc/install)
- [Operator SDK](https://sdk.operatorframework.io/docs/installation/install-operator-sdk/)

## Development environment

The development environment can be of two types:

- one using minikube (or colima )
- one using kind

### With minikube

#### Setup a local docker registry

Use this repository to setup a local private registry: [docker registry in kubernetes](https://github.com/fredericbarrau/docker-registry-in-kubernetes)

#### Build the pong image and push it to the local registry

```bash
docker login docker-registry:30000
# User: docker-user
# Password: mYp4s50rD§
docker build -t pong:latest -f Dockerfile .

docker tag pong:latest docker-registry:30000/pong:latest
# Then push to check if auth & access is OK
docker push docker-registry:30000/alpine:latest
# Check if the image is on the private registry:
╰─$ curl -skX GET -udocker-user:mYp4s50rD§ https://docker-registry:30000/v2/pong/tags/list |jq
# Should output something like:
{
  "name": "pong",
  "tags": [
    "latest"
  ]
}
```

#### Workflow

[ASDF](https://asdf-vm.com) is recommended, as the version of the go compiler is important. Install it with:

```bash
asdf plugin add golang
asdf install golang
```

Ensure the go module management is enabled:

```bash
export GO111MODULE=on
```

Configure the operator sdk to use the local registry:

```text
# Change the makefile:
-IMG ?= controller:latest
+IMG ?= $(IMAGE_TAG_BASE):$(VERSION)
```

Build & push the docker image to the private registry:

  ```bash
  export IMAGE_TAG_BASE=docker-registry:30000/fredericbarrau.games.com/pong-operator
  make docker-build docker-push
  ```

Now, deploy the built image into the dev cluster:

```bash
make deploy
```

---

First deploy may as the namespace pong-operator-controller has no right to fetch from the private registry. Configure the authentication to the docker registry for this namespace:

```bash
#copy the auth to the pong-operator-controller:
k get secret registry-secret -o yaml|sed  '/namespace:/d'|k apply -n pong-operator-system -f - 1 ↵
secret/registry-secret created
```

Make the registry secret the default to be used by the pong-operator-controller-manager SA of the pong-operator-system:

```bash
╰─$ k patch sa pong-operator-controller-manager -n pong-operator-system -p '{"imagePullSecrets":[{"name":"registry-secret"}]}'
```

And rollout the deployment of the controller:

```bash
k rollout restart deployment pong-operator-controller-manager -n pong-operator-system
```

This should be done once

---

Then install the CRD into the cluster:

```bash
make install
```

For testing, create an instance of the CRD:

```bash
kubectl apply -k config/samples/
```

### With kind

The workflow could be simplified with kind, as the private registry is not needed.

First install a cluster with kind:

```bash
kind create cluster
```

Then, build the images of the operator and deploy it to the cluster:

```bash
make docker-build
kind load fredericbarrau.bzh/pong-operator:0.0.5
# You will also need the image for the pong game; build it and load it
cd ..
make docker-build
kind load fredericbarrau.bzh/pong:0.0.5
```

**Note:** The `kind load` command is used to load the image into the kind cluster. This is a kind-specific command.

Then `make deploy / make install` and install the samples as above.
