#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

sh ../server.sh

sh approle-setup.sh

vault read -field=role_id \
  auth/approle/role/example/role-id \
  > approle-role.id
vault write -f -field=secret_id \
  auth/approle/role/example/secret-id \
  > approle-secret.id

rm ~/.vault-token

vault write -field=token \
  auth/approle/login \
  role_id=$(cat 'approle-role.id') \
  secret_id=$(cat 'approle-secret.id') \
  > approle.token

vault login $(cat approle.token)
vault print token
