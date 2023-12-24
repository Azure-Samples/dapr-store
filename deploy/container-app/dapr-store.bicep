// ============================================================================
// Deploy to Azure using Bicep and Azure Container Apps
// ============================================================================

targetScope = 'subscription'

@description('Name used for resource group, and default base name for all resources')
param appName string = 'dapr-store'

@description('Azure region for all resources')
param location string = deployment().location

@description('Container image')
param imageBase string = 'ghcr.io/azure-samples/dapr-store'

@description('Version of the container image')
param imageTag string = 'latest'

@description('Enable authentication with Entra ID, by setting a client ID')
param authClientID string = '7faeb5dc-3110-4e4d-81d6-da6b56b1b955'

// ===== Variables ============================================================

// Using my own benc-uk/nanoproxy-proxy as a simple HTTP proxy for the API gateway
// NGINX had issues which I couldn't resolve
var imageGateway = 'ghcr.io/benc-uk/nanoproxy-proxy:0.0.4'

var imageProducts = '${imageBase}/products:${imageTag}'
var imageOrders = '${imageBase}/orders:${imageTag}'
var imageUsers = '${imageBase}/users:${imageTag}'
var imageCart = '${imageBase}/cart:${imageTag}'
var imageFrontend = '${imageBase}/frontend-host:${imageTag}'

var daprTableName = 'daprstate2222'

// ===== Base shared resources ==================================================

resource resGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: appName
  location: location
}

module logAnalytics './modules/log-analytics.bicep' = {
  scope: resGroup
  name: 'logs-deploy'
}

module storageAcct 'modules/storage.bicep' = {
  scope: resGroup
  name: 'storage-deploy'
  params: {
    name: 'daprstore'
  }
}

module storageTable 'modules/storage-table.bicep' = {
  scope: resGroup
  name: 'storage-table-deploy'
  params: {
    name: daprTableName
    storageAccountName: storageAcct.outputs.name
  }
}

module serviceBus 'modules/service-bus.bicep' = {
  scope: resGroup
  name: 'service-bus-deploy'
  params: {
    sku: 'Standard'
    topicName: 'orders-queue'
  }
}

module containerAppEnv './modules/app-env.bicep' = {
  scope: resGroup
  name: 'app-env-deploy'
  params: {
    logAnalyticsName: logAnalytics.outputs.name
    logAnalyticsResGroup: resGroup.name
  }
}

// ===== Dapr components ======================================================

module daprComponentState './modules/dapr-component.bicep' = {
  scope: resGroup
  name: 'dapr-store-deploy'
  params: {
    name: 'statestore' // Dont' change this, unless you also change a lot of other things
    environmentName: containerAppEnv.outputs.name
    componentType: 'state.azure.tablestorage'

    componentMetadata: [
      {
        name: 'accountName'
        value: storageAcct.outputs.name
      }
      {
        name: 'tableName'
        value: daprTableName
      }
      {
        name: 'accountKey'
        value: storageAcct.outputs.accountKey
      }
    ]

    scopes: [ 'cart', 'users', 'orders' ]
  }
}

module daprComponentPubsub './modules/dapr-component.bicep' = {
  scope: resGroup
  name: 'dapr-pubsub-deploy'
  params: {
    name: 'pubsub' // Dont' change this, unless you also change a lot of other things
    environmentName: containerAppEnv.outputs.name
    componentType: 'pubsub.azure.servicebus.topics'

    componentMetadata: [
      {
        name: 'connectionString'
        value: serviceBus.outputs.connectionString
      }
    ]

    scopes: [ 'cart', 'orders' ]
  }
}

// ===== Deploy the API gateway =============================================

module apiGateway './modules/app.bicep' = {
  scope: resGroup
  name: 'apigw-deploy'
  params: {
    name: 'api-gateway'
    environmentId: containerAppEnv.outputs.id

    image: imageGateway

    daprAppId: 'api-gateway'
    daprAppPort: 8080

    ingressExternal: true
    ingressPort: 8080

    envs: [
      {
        name: 'CONFIG_B64'
        value: loadFileAsBase64('./gateway-conf.yaml')
      }
      {
        name: 'DEBUG'
        value: '1'
      }
    ]
  }
}

// ===== Deploy the Dapr store container apps =============================================

module productsApp './modules/app.bicep' = {
  scope: resGroup
  name: 'products-deploy'
  params: {
    name: 'products'
    environmentId: containerAppEnv.outputs.id

    image: imageProducts

    probePath: '/health'
    probePort: 9002

    daprAppId: 'products'
    daprAppPort: 9002

    envs: [
      {
        name: 'AUTH_CLIENT_ID'
        value: authClientID
      }
    ]
  }
}

module ordersApp './modules/app.bicep' = {
  scope: resGroup
  name: 'orders-deploy'
  params: {
    name: 'orders'
    environmentId: containerAppEnv.outputs.id

    image: imageOrders

    probePath: '/health'
    probePort: 9004

    daprAppId: 'orders'
    daprAppPort: 9004

    envs: [
      {
        name: 'AUTH_CLIENT_ID'
        value: authClientID
      }
    ]
  }
}

module usersApp './modules/app.bicep' = {
  scope: resGroup
  name: 'users-deploy'
  params: {
    name: 'users'
    environmentId: containerAppEnv.outputs.id

    image: imageUsers

    probePath: '/health'
    probePort: 9003

    daprAppId: 'users'
    daprAppPort: 9003

    envs: [
      {
        name: 'AUTH_CLIENT_ID'
        value: authClientID
      }
    ]
  }
}

module cartApp './modules/app.bicep' = {
  scope: resGroup
  name: 'cart-deploy'
  params: {
    name: 'cart'
    environmentId: containerAppEnv.outputs.id

    image: imageCart

    probePath: '/health'
    probePort: 9001

    daprAppId: 'cart'
    daprAppPort: 9001

    envs: [
      {
        name: 'AUTH_CLIENT_ID'
        value: authClientID
      }
    ]
  }
}

module frontendApp './modules/app.bicep' = {
  scope: resGroup
  name: 'frontend-deploy'
  params: {
    name: 'frontend'
    environmentId: containerAppEnv.outputs.id

    image: imageFrontend

    ingressExternal: false
    ingressPort: 8000

    envs: [
      {
        name: 'AUTH_CLIENT_ID'
        value: authClientID
      }
    ]
  }
}

// ===== Outputs ==============================================================

output storeURL string = 'https://${apiGateway.outputs.fqdn}/'
