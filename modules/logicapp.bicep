param appName string
param location string
param subId string
param apiId string = '/subscriptions/${subId}/providers/Microsoft.Web/locations/switzerlandnorth/managedApis/sharepointonline'
var logicAppDefinition = json(loadTextContent('../logicapp/definition.json'))

resource spo 'Microsoft.Web/connections@2016-06-01' = {
  name: 'sharepointonline'
  location: location
  properties: {
    api: {
      id: apiId
      type: 'Microsoft.Web/locations/managedApis'
    }
  }
}

resource logicapp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: appName
  location: location
  properties: {
    definition: logicAppDefinition.definition
    parameters: {
      '$connections': {
        value: {
          sharepointonline: {
            connectionId: spo.id
            connectionName: spo.name
            id: spo.properties.api.id
          }
        }
      }
    }
  }
}
