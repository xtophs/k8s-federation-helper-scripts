#!/bin/bash

set -e

REGSITRY=xtoph
IMAGE=azure-federation-e2e
VERSION=xtoph.3

docker load -i  _output/release-images/amd64/fcp-amd64.tar
docker tag gcr.io/google_containers/fcp-amd64:v1.9.0-alpha.2.60_430416309f9e58-dirty ${REGSITRY}/${IMAGE}:${VERSION}
docker push ${REGSITRY}/${IMAGE}:${VERSION}
