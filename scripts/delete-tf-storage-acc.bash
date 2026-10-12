#!/bin/bash

STORAGE_ACCOUNT_NAME="${storage_account_name:-statefiles12345}"
RESOURCE_GROUP_NAME="${resource_group_name:-terraform-be-rg}"

# Authenticate with Azure
bash ./azure-login.sh

# Delete storage account holding the state file
az storage account delete \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --yes \
    && echo "[SUCCESS] Storage account deleted successfully." \
    || echo "[ERROR] Deleting storage account failed."

# Delete the resource group
az group delete \
    --name $RESOURCE_GROUP_NAME \
    --yes \
    && echo "[SUCCESS] Resource group deleted successfully." \
    || echo "[ERROR] Failed to delete the resource group."
