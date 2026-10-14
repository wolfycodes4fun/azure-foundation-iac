#!/bin/bash

APPLICATION_CLIENT_ID="$APPLICATION_CLIENT_ID"
APPLICATION_CLIENT_SECRET="$APPLICATION_CLIENT_SECRET"
APPLICATION_TENANT_ID="$APPLICATION_TENANT_ID"

if az login --service-principal \
    --username "$APPLICATION_CLIENT_ID" \
    --password "$APPLICATION_CLIENT_SECRET" \
    --tenant "$APPLICATION_TENANT_ID"; then
    echo "[SUCCESS] Logged into Azure successfully."
else
    EXIT_STATUS=$?
    echo "[CRITICAL] Logging into Azure failed with exit code $EXIT_STATUS." >&2
    exit $EXIT_STATUS
fi
    