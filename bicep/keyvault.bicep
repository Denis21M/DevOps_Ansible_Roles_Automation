param location string = resourceGroup().location

@secure()
param adminUsername string

@secure()
param adminPassword string

@secure()
param kvName string

@description('ObjectId of the service principal used in GitHub Actions (not the subscriptionId)')
param spObjectId string

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: kvName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: spObjectId
        permissions: {
          secrets: [
            'get'
            'set'
            'list'
          ]
        }
      }
    ]
    enableSoftDelete: true
  }
}

resource usernameSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: keyVault
  name: 'vmAdminUsername'
  properties: {
    value: adminUsername
  }
}

resource passwordSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: keyVault
  name: 'vmAdminPassword'
  properties: {
    value: adminPassword
  }
}
