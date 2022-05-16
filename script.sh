#!/bin/bash

containerCount=$(az container list \
                --resource-group rg-weatherforecast-service-prod-eastus \
                --query "length([?name == 'aci-weatherforecast-service-prod-eastus'])")

if [ "$containerCount" -gt "0" ] 
then
    echo "Deletando container..."
    az container delete \
    --name aci-weatherforecast-service-prod-eastus \
    --resource-group rg-weatherforecast-service-prod-eastus \
    --yes
fi
  
