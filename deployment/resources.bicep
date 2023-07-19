param automationAccountName string
param logAnalyticsWorkspace string
param storageAccountName string
param location string = resourceGroup().location

resource auto 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

resource log 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspace
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource stg 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource link 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: 'Automation'
  parent: log
  properties: {
    resourceId: auto.id
  }
}

output workspaceId string = log.properties.customerId
output workspaceResourceId string = log.id
output automationAccountResourceId string = auto.id
