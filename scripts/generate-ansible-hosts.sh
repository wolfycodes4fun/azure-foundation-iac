#!/bin/bash

INPUT_FILE=$1
OUTPUT_FILE="ansible/inventory/hosts.ini"

mkdir -p "$(dirname "$OUTPUT_FILE")"
echo "[backendservers]" > "$OUTPUT_FILE"

HOST_PORT=2222
while IFS= read -r ip_addr || [ -n "$ip_addr" ]; do
    # Establish tunnel
    az network bastion tunnel \
        --name "az-foundation-iac-dev-bastion-host" \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --target-ip-address "${ip_addr}" \
        --resource-port 22 \
        --port $HOST_PORT &
    
    # Write host entries alongside their respective ports to inventory file
    echo "be-server-${HOST_PORT} ansible_host=127.0.0.1 ansible_port=${HOST_PORT}" >> "$OUTPUT_FILE"
    HOST_PORT=$((HOST_PORT + 1))
done < "$INPUT_FILE"

# Append variables to use with SSH
cat <<EOF >> "$OUTPUT_FILE"

[backendservers:vars]
ansible_user=${VM_ADMIN_USER}
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
EOF