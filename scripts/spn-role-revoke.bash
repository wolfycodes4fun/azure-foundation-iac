#! /bin/bash

STORAGE_ACCOUNT_NAME="${STORAGE_ACCOUNT_NAME:-devstatefiles12345}"
STORAGE_ACCOUNT_CONTAINER_NAME="${storage_account_container_name:-statefiles}"
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
SPN_DISPLAY_NAME=$(az ad sp show --id $(az account show --query user.name --output tsv) --query displayName --output tsv)

SPN_OBJECT_ID=$(az ad sp show \
    --id $(az account show --query user.name -o tsv) \
    --query id \
    --output tsv)

STORAGE_ACC_RESOURCE_ID=$(az storage account show \
    --name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --query id \
    --output tsv)

CONTAINER_RESOURCE_ID="${STORAGE_ACC_RESOURCE_ID}/blobServices/default/containers/${STORAGE_ACCOUNT_CONTAINER_NAME}"

# Revoke the role of Storage Blob Data Reader to provisioned storage account container
if az role assignment create \
    --assignee-object-id "$SPN_OBJECT_ID" \
    --assignee-principal-type ServicePrincipal \
    --role "Storage Blob Data Contributor" \
    --scope "${CONTAINER_RESOURCE_ID}" \
    --output none; then
    echo "[SUCCESS] Granted Storage Blob Data Contributor to ${SPN_DISPLAY_NAME}."
else
    echo "[CRITICAL] Failed to grant Storage Blob Data Contributor to ${SPN_DISPLAY_NAME}."

# Assign the role of Contributor to the SPN
az role assignment create \
    --assignee-object-id "$SPN_OBJECT_ID" \
    --assignee-principal-type ServicePrincipal \
    --role "Contributor" \
    --scope "/subscriptions/$SUBSCRIPTION_ID" \
    --output none; then
    echo "[SUCCESS] Granted Contributor to ${SPN_DISPLAY_NAME} for the subscription."
else
    echo "[CRITICAL] Failed to grant Contributor to ${SPN_DISPLAY_NAME} for the subscription."