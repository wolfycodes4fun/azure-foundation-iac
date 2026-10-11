#!/bin/bash

STORAGE_ACCOUNT_NAME="${storage_account_name:-statefiles12345}"
RESOURCE_GROUP_NAME="${resource_group_name:-terraform-be-rg}"

# Delete storage account holding the state file
az storage account delete \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --yes

# Delete the resource group
az group delete \
    --name $RESOURCE_GROUP_NAME \
    --yes
