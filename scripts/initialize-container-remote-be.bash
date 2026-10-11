#!/bin/bash

RESOURCE_GROUP_NAME="$resource_group_name"
LOCATION="$region"
STORAGE_ACCOUNT_NAME="$storage_account_name"
STORAGE_ACCOUNT_CONTAINER_NAME="$storage_account_container_name"

echo "location: $LOCATION"
echo $RESOURCE_GROUP_NAME

# Create resource group
az group create \
--name $RESOURCE_GROUP_NAME \
--location $LOCATION

# Create storage account & modify it's properties
az storage account create \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --access-tier Hot \
    --location $LOCATION \
    --sku Standard_LRS \
    --allow-blob-public-access false \
    --encryption-services blob \
    --min-tls-version TLS1_2

# az 

az storage container create \
    --name $STORAGE_ACCOUNT_CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --auth-mode login \
    --public-access off

# Add RBAC role assignment to the Terraform user
USER_OBJECT_ID=$(az ad signed-in-user show --query id --output tsv)
STORAGE_ACCOUNT_ID=$(az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --query id --output tsv)

az role assignment create \
    --role "Storage Blob Data Owner" \
    --assignee $USER_OBJECT_ID \
    --scope $STORAGE_ACCOUNT_ID \
