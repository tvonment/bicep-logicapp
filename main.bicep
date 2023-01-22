targetScope = 'subscription'

@description('The Azure region into which the resources should be deployed.')
param location string = deployment().location

@description('The Prefix for the Resources')
param prefix string = 'logicapp'

param envs array = [
  {
    name: 'test'
  }
]

resource rGroups 'Microsoft.Resources/resourceGroups@2021-04-01' = [for env in envs: {
  name: 'rg-${env.name}-${prefix}'
  location: location
}]

module apps 'modules/logicapp.bicep' = [for env in envs: {
  scope: resourceGroup('rg-${env.name}-${prefix}')
  name: '${env.name}-app-${uniqueString('rg-${env.name}-${prefix}')}'
  dependsOn: rGroups
  params: {
    appName: 'testapp'
    location: location
  }
}]
