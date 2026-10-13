#!/bin/bash

APPLICATION_CLIENT_ID="$client_id"
APPLICATION_CLIENT_SECRET="$client_secret"
APPLICATION_TENANT_ID="$tenant_id"

az login --service-principal \
    --username $APPLICATION_CLIENT_ID \
    --password $APPLICATION_CLIENT_SECRET \
    --tenant $APPLICATION_TENANT_ID \
    && echo "[SUCCESS] Logged into Azure successfully." \
    || { echo "[CRITICAL] Logging into Azure failed with exit code $?." >&2; \
    exit $?; }
    