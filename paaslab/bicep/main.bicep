@description('The name of the site')
param siteName string = 'tailspintoys'

param workshop string = 'biceplab'

@description('unique suffix')
param suffix string = uniqueString(resourceGroup().id)

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The SKU of App Service Plan.')
param sku string = 'S1'

param pguser string =  'pgsqladmin'

@secure()
param pgpwd string = 'P@ssw0rd12354'

// @description('The Runtime stack of current web app')
// param linuxFxVersion string = 'DOTNETCORE|5.0'

//var sitecount = 2  // 0..2
var env = [
  'dev'
  'qa'
  'prod'
]

var envcount = length(env)

resource appServicePlanName 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: '${siteName}-${workshop}-plan'
  location: location
  sku: {
    name: sku
    tier: 'Standard'
  }
}

resource appservice 'Microsoft.Web/sites@2020-06-01' = [for i in range(0, envcount): {
  //name: webAppName
  name: '${siteName}-${workshop}-${env[i]}-${suffix}'
  location: location
  properties: {
    serverFarmId: appServicePlanName.id
    siteConfig: {
      connectionStrings: [
        {
          name: 'Database'
          type: 'PostgreSQL'
          connectionString: 'Server=${postgresserver[i].name};User Id=${pguser};Password=${pgpwd}'
        }
      ]
    }
  }
}]

resource webAppSlot 'Microsoft.Web/sites/slots@2020-06-01' = [for i in range(0, envcount): {
  name: '${siteName}-${workshop}-${env[i]}-${suffix}/staging'
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanName.id
  }
  dependsOn: [
    appservice
  ]
}]

resource postgresserver 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = [for i in range(0, envcount): {
  name: '${siteName}-${workshop}-${env[i]}-pgsql${suffix}'
  location: location
  sku: {
    name: 'GP_Gen5_2'
  }
  properties: {
    createMode: 'Default'
    administratorLoginPassword: pgpwd
    administratorLogin:  pguser 
    sslEnforcement: 'Enabled'
  }
}]

resource postgresqlfirewallrule 'Microsoft.DBforPostgreSQL/servers/firewallRules@2017-12-01' = [for i in range(0, envcount): {
  name: '${siteName}-${workshop}-${env[i]}-pgfw'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
  parent: postgresserver[i]
}]

resource postgresqldatabase 'Microsoft.DBforPostgreSQL/servers/databases@2017-12-01' = [for i in range(0, envcount): {
  name: '${siteName}-${workshop}-${env[i]}-db'
  properties: {
    charset: 'UTF8'
    collation: 'English_United States.1252'
  }
  parent: postgresserver[i]
}]
