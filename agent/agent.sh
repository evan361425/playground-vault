#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

sh ../server.sh || exit 1

sh ../pki/pki-setup.sh
sh ../authenticate/approle-setup.sh

# Create app role id/secret
vault read -field=role_id \
  auth/approle/role/example/role-id \
  > src/role.id
vault write -f -field=secret_id \
  auth/approle/role/example/secret-id \
  > src/secret.id

# Policy
vault policy write agent policy.hcl
vault write auth/approle/role/example/policies agent
vault write /auth/approle/role/example -token_policies="policy.hcl"

# Make token enable do some things
vault secrets enable -path=playground kv
vault kv put playground/exist foo=bar hello=world

vault agent -config="config.hcl"

# Clean up
: '
vault secrets disable int-pki
vault secrets disable root-pki
vault auth disable approle
vault secrets disable playground
'