param location string = resourceGroup().location

@secure()
param adminUsername string

@secure()
param adminPassword string

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'nginx-vm-pip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'nginx-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.1.0.0/24'
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'nginx-vm-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          publicIPAddress: {
            id: publicIP.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'windows-nginx-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    osProfile: {
      computerName: 'NGINXVM'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsSe
