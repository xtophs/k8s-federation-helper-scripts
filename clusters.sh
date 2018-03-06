#!/bin/bash

declare -a rgs=("xtoph-fed-east" "xtoph-fed-west" "xtoph-fed-sc")
declare -a locations=("eastus" "westus" "southcentralus" )

for ((i=0;i<${#rgs[@]};i++)) 
do
    echo creating rg ${rgs[$i]} in ${locations[$i]}
    az group create -l ${locations[$i]} -n ${rgs[$i]} 
    az group deployment create -g ${rgs[$i]} \
       --template-file _output/${rgs[$i]}/azuredeploy.json \
       --parameters @_output/${rgs[$i]}/azuredeploy.parameters.json --no-wait
done

ips=()
for ((i=0;i<${#rgs[@]};i++)) 
do

    while true; do
        ready=$(az group deployment show -g ${rgs[i]} -n azuredeploy --query properties.provisioningState --output tsv)
        if [ $ready == "Succeeded" ]; then
            echo Deployment $rgs[i] succeeded 
            ipName=$(az resource list -g ${rgs[$i]} --resource-type Microsoft.Network/publicIPAddresses --query [0].name --out tsv) 
            echo Found IP address $ipName

            ipAddress=$(az resource show -g ${rgs[$i]} --resource-type Microsoft.Network/publicIPAddresses -n $ipName --query properties.ipAddress --out tsv)
            echo Address is $ipAddress

            ips+=($ipAddress)
            break
        else
            sleep 300
        fi

    done
done

echo declare -a 'ips=('${ips[@]}')' > ./ips.env