#!/usr/bin/env bash

grant_role() {
    local role="$1"
    local scope="$2"

    local logged_user_name="${3:-$(az ad sp show \
        --id $(az account show --query user.name --output tsv) \
        --query displayName \
        --output tsv)}"
    echo "Username: ${logged_user_name}"

    local logged_user_id="${4:-$(az ad sp show \
        --id $(az account show --query user.name -o tsv) \
        --query id \
        --output tsv)}"
    echo "User ID: ${logged_user_id}"

    # Assign specified role to logged in user
    if az role assignment create \
        --assignee-object-id "${logged_user_id}" \
        --assignee-principal-type ServicePrincipal \
        --role "${role}" \
        --scope "${scope}" \
        --output none; then
        echo "[SUCCESS] Granted ${role} to ${logged_user_name}."
    else
        echo "[CRITICAL] Failed to grant ${role} to ${logged_user_name}."
    fi
}
