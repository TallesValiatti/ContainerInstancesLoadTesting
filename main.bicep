
// az deployment group create --name weatherforecast-service --resource-group  rg-weatherforecast-service-prod-eastus --template-file main.bicep
// az container delete --name aci-weatherforecast-service-prod-eastus --resource-group rg-weatherforecast-service-prod-eastus --yes

@description('Default location')
param defaultLocation string = resourceGroup().location

@description('Azure Container registry Name')
param acrName string = 'acrweatherforecastprodeastus'

@description('Azure Container instance Name')
param aciName string = 'aci-weatherforecast-service-prod-eastus'

@description('Container image to deploy')
param image string = 'acrweatherforecastprodeastus.azurecr.io/weatherforecast-service:latest'

@description('Port to open on the container and the public IP address.')
param port int = 80

@description('DNS Name')
param dnsNameLabel string = 'weatherforecast'

@description('The number of CPU cores to allocate to the container.')
param cpuCores int = 1

@description('The amount of memory to allocate to the container in gigabytes.')
param memoryInGb int = 2

@description('The behavior of Azure runtime if container has stopped.')
@allowed([
  'Always'
  'Never'
  'OnFailure'
])
param restartPolicy string = 'Always'

// Acr
resource acrResource 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: acrName
}

// Aci
resource name_resource 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: aciName
  location: defaultLocation
  properties: {
    containers: [
      {
        name: aciName
        properties: {
          image: image
          ports: [
            {
              port: port
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: restartPolicy
    imageRegistryCredentials: [
      {
        server: acrResource.properties.loginServer
        username: acrResource.name
        password: acrResource.listCredentials().passwords[0].value
      }
    ]
    ipAddress: {
      type: 'Public'
      ports: [
        {
          port: port
          protocol: 'TCP'
        }
      ]
      dnsNameLabel: dnsNameLabel
    }
  }
}
