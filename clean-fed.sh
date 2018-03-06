#!/bin/bash

set -e

hostContextName=
federationName=

declare -a contexts=("") 

. ./setup.env

clean_fed()
{
  _output/dockerized/bin/linux/amd64/kubefed unjoin

}

clean_cluster()
{
    local clusterContextName=${1}

    kubectl config use-context ${clusterContextName}
    kubectl delete clusterrolebinding federation-controller-manager:${federationName}-${clusterContextName}-${hostContextName}
    kubectl delete  serviceaccounts --namespace=federation-system default
    kubectl delete  serviceaccounts --namespace=federation-system ${clusterContextName}-${hostContextName}
    kubectl delete clusterroles federation-controller-manager:${federationName}-${clusterContextName}-${hostContextName}
}

kubectl delete namespace federation-system --context ${hostContextName}

for i in "${contexts[@]}"
do
  clean_cluster "${i}"
done

