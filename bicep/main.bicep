param location string = resourceGroup().location

param adminUsername string

@secure()
param adminPassword string

module vm1 'windows-iis-vm.bicep' = {
  name: 'iisVmDeployment'
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module vm2 'windows-nginx-vm.bicep' = {
  name: 'nginxVmDeployment'
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
