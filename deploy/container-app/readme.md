# Deploy to Azure with Container Apps

This folder holds Bicep template and modules to deploy Dapr Store to Azure using the following

- Azure Container Apps - to host all of the services
- Azure Storage - as a state store, using Azure Tables
- Azure Service Bus - for pub-sub

## Deployment

Use the Azure CLI to deploy the template, by default it deploys to a resource group called `dapr-store` you can pick any location you like of course.

```bash
cd deploy/container-app 

az deployment sub create --name dapr-store \
--location uksouth \
--template-file dapr-store.bicep
```