#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

sh ../server.sh || exit 1

token=$(vault print token)

vault token lookup $token

# List accessor
vault list auth/token/accessors

# Policy
vault policy write token-example policy.hcl

# Batch token
vault token create \
  -type=batch \
  -orphan=true \
  -policy=token-example

# Wrap token
wrapped=$(vault token -field=wrapping_token create \
   -policy=token-example \
   -wrap-ttl=120)

# Logout
rm ~/.vault-token

# When you are not authenticated you can also get wrapped token
vault unwrap $wrapped

vault login $(../root.token)

# Revoke token by accessor
accessor=$(vault token -field=wrapping_accessor create \
   -policy=token-example \
   -wrap-ttl=120)

vault token revoke -accessor $(accessor)
