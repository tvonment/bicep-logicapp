@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The Prefix for the Resources')
param env string = 'test'
param appName string = 'logicapp'

module apps 'modules/logicapp.bicep' = {
  name: '${env}-${appName}-deployment'
  params: {
    appName: '${env}-${appName}'
    location: location
  }
}
