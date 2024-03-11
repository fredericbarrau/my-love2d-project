# Deployment as a K8S operator

This application will be deployed as a kubernetes cluster. This folder contains the necessary files to deploy the application, as well as all the elements needed to setup a development environment.

Ready ? Let's go !

## Prerequisites

- [Docker](https://www.docker.com/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) or any other kubernetes cluster
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- [golang](https://golang.org/doc/install)
- [Operator SDK](https://sdk.operatorframework.io/docs/installation/install-operator-sdk/)

## Development environment

### Setup a local private registry

Use this repository to setup a local private registry: [docker registry in kubernetes](https://github.com/fredericbarrau/docker-registry-in-kubernetes)

### Build the pong image and push it to the local registry

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

## Workflow

TODO