#!/bin/bash

DOCR_REGISTRY=registry.digitalocean.com/ntate
DOCR_REPO=hello-world
DOCR_TAG=v1
FULL_IMAGE=$DOCR_REGISTRY/$DOCR_REPO/$DOCR_TAG

docker build -t $FULL_IMAGE .
docker push $FULL_IMAGE

yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq yq "$@"
}
yq write -i chart/values.yaml image.repository "$DOCR_REGISTRY/$DOCR_REPO"
yq write -i chart/values.yaml image.tag "$DOCR_TAG"


export HELM_EXPERIMENTAL_OCI=1
HELM_REPO=helm-repository
CHART_NAME=hello-world
CHART_VERSION=0.1.0
helm chart save ./chart $DOCR_REGISTRY/$HELM_REPO/$CHART_NAME:$CHART_VERSION 
helm chart push $DOCR_REGISTRY/$HELM_REPO/$CHART_NAME:$CHART_VERSION 
