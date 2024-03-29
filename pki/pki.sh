#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

sh ../server.sh || exit 1

sh pki-setup.sh

# Policy
vault policy write intermediate-pki policy.hcl
# Token
vault token create \
  -field=token \
  -display_name=intermediate-token \
  -policy=intermediate-pki \
  -ttl=1h > pki.token

# Get certificate manually
: '
vault write -format=json \
  int-pki/issue/example-dot-com \
  common_name="blah.example.com" | tee \
  >(jq -r .data.ca_chain > cert/client.ca-chain.pem) \
  >(jq -r .data.certificate > cert/client.crt) \
  >(jq -r .data.private_key > cert/client.pem) \
  > /dev/null
'

# Do truncate CRL
: '
vault write root-pki/tidy tidy_revoked_certs=true
vault write int-pki/tidy tidy_revoked_certs=true
'

# Clean up
: '
vault secrets disable int-pki
vault secrets disable root-pki
'
