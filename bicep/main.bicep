param location string = resourceGroup().location
@secure()
param adminPassword string

module keyvault 'keyvault.bicep' = {
  name: 'keyVaultSetup'
  params: {
    location: location
    adminPassword: adminPassword
  }
}

module vm1 'windows-iis-vm.bicep' = {
  name: 'iisVmDeployment'
  params: {
    location: location
  }
}

module vm2 'windows-nginx-vm.bicep' = {
  name: 'nginxVmDeployment'
  params: {
    location: location
  }
}
