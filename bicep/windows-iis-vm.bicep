param location string = resourceGroup().location

@secure()
param adminUsername string

@secure()
param adminPassword string

// Public IP for IIS VM
resource publicIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'iis-vm-pip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'iis-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// Network Interface for IIS VM
resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'iis-vm-nic'
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

// IIS VM Definition
resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'windows-iis-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    osProfile: {
      computerName: 'IISVM'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
