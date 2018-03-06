#!/bin/bash

. ./setup.env
. ./ips.env

declare -a locations=("east" "west" "sc")

for ((i=0;i<${#ips[@]};i++)) 
do
    echo getting kubeconfig ${locations[$i]}
    scp azureuser@${ips[$i]}:/home/azureuser/.kube/config config.${locations[$i]}
done

