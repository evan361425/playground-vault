#!/bin/bash

sh ../server.sh || exit 1

# Start standby node
vault server -config=config.hcl &

sleep 2

export VAULT_ADDR='http://127.0.0.1:8100'

vault write sys/unseal key=$(cat '../.key')

vault login $(cat '../root.token')

# New Vault HA mode is standby
vault status

# Step down active node
export VAULT_ADDR='http://127.0.0.1:8200'

vault status
vault operate step-down

# New Vault HA mode is active
export VAULT_ADDR='http://127.0.0.1:8100'
vault status
