#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

sh ../server.sh

vault auth enable github
vault write auth/github/config organization=104corp

rm ~/.vault-token

vault login \
  -field=token \
  -method=github \
  -token=$(cat github.access.token) \
  > github.token

vault login $(cat github.token)
vault print token
