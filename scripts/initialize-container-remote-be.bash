#!/bin/bash

RESOURCE_GROUP_NAME="${resource_group_name:-terraform-be-rg}"
LOCATION="${region:-eastus}"
STORAGE_ACCOUNT_NAME="${storage_account_name:-statefiles12345}"
STORAGE_ACCOUNT_CONTAINER_NAME="${storage_account_container_name:-statefiles}"

# Authenticate with Azure
bash ./azure-login.bash

# Create resource group
az group create \
    --name $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    && echo "[SUCCESS] Created resource group successfully." \
    || echo "[ERROR] Creating resource group failed."

# Create storage account & modify it's properties
az storage account create \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --access-tier Hot \
    --location $LOCATION \
    --sku Standard_LRS \
    --allow-blob-public-access false \
    --encryption-services blob \
    --min-tls-version TLS1_2 \
    && echo "[SUCCESS] Storage account created successfully." \
    || echo "[ERROR] Failed to create storage account."

az storage account blob-service-properties update \
    --account-name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --enable-versioning true \
    --container-retention --enable-container-delete-retention false \
    --enable-change-feed false \
    && echo "[SUCCESS] Storage account config updated." \
    || echo "[WARN] Failed to update storage account config."

# Create container in storage account to store state file
az storage container create \
    --name $STORAGE_ACCOUNT_CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --auth-mode login \
    --public-access off \
    && echo "[SUCCESS] Created container successfully." \
    || echo "[ERROR] Failed to create container."
