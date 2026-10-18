#!/usr/bin/env bash

revoke_role() {
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

    # Revoke specified role from the logged in user
    if az role assignment delete \
        --assignee-object-id "${logged_user_id}" \
        --assignee-principal-type ServicePrincipal \
        --role "${role}" \
        --scope "${scope}" \
        --output none; then
        echo "[SUCCESS] Revoked ${role} from ${logged_user_name}."
    else
        echo "[CRITICAL] Failed to revoke ${role} from ${logged_user_name}."
    fi
}