#!/bin/bash

set -e

hostContextName=
federationName=
zoneName=

declare -a contexts=("")

. ./setup.env
 
# run from $GOPATH/src/k8s.io/kubernetes/federation
_output/dockerized/bin/linux/amd64/kubefed init ${federationName} --host-cluster-context=${hostContextName} --image=${image} --dns-provider="azure-azuredns" --dns-zone-name=${zoneName} --dns-provider-config=${confPath} --v=5

kubectl create namespace default --context=${federationName}

for i in "${contexts[@]}"
do
    echo Joining ${i}
    _output/dockerized/bin/linux/amd64/kubefed join ${i} --host-cluster-context ${hostContextName} --cluster-context ${i}
done
