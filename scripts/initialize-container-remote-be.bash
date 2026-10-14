#!/bin/bash

RESOURCE_GROUP_NAME="${RESOURCE_GROUP_NAME:-terraform-be-rg}"
LOCATION="${REGION:-eastus}"
STORAGE_ACCOUNT_NAME="${STORAGE_ACCOUNT_NAME:-devstatefiles12345}"
STORAGE_ACCOUNT_CONTAINER_NAME="${storage_account_container_name:-statefiles}"

echo "Resource group name: $RESOURCE_GROUP_NAME"
echo "Location: $LOCATION"
echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"

# Create resource group
az group create \
    --name $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    --output none \
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
    --output none \
    && echo "[SUCCESS] Storage account created successfully." \
    || echo "[ERROR] Failed to create storage account."

az storage account blob-service-properties update \
    --account-name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --enable-versioning true \
    --container-retention --enable-container-delete-retention false \
    --enable-change-feed false \
    --output none \
    && echo "[SUCCESS] Storage account config updated." \
    || echo "[WARN] Failed to update storage account config."

# Create container in storage account to store state file
az storage container create \
    --name $STORAGE_ACCOUNT_CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --auth-mode login \
    --public-access off \
    --output none \
    && echo "[SUCCESS] Created container successfully." \
    || echo "[ERROR] Failed to create container."
