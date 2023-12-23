# Deploy to Azure with Container Apps

This folder holds Bicep template and modules to deploy Dapr Store to Azure using the following

- **Azure Container Apps** - to host all of the services
- **Azure Storage** - as a state store, using Azure Tables
- **Azure Service Bus** - for pub-sub

Note. It doesn't use NGINX for the API gateway, and instead another [reverse proxy called NanoProxy](https://github.com/benc-uk/nanoproxy) is used due to problems getting NGINX to work in Container Apps.

## Deployment

Use the Azure CLI to deploy the template, by default it deploys to a resource group called `dapr-store`, which can be changed with the *appName* parameter.
The location for resources will be the same as the location selected for the deployment on the command line.


```bash
cd deploy/container-app 

az deployment sub create --name dapr-store \
--location uksouth \
--template-file dapr-store.bicep
```