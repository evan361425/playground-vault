#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

sh ../server.sh || exit 1

sh pki-setup.sh

# Policy
vault policy write intermediate-pki policy.hcl
# Token
vault token create \
  -field=token \
  -policy=intermediate-pki \
  -ttl=1h > pki.token

# Get certificate
# vault write -format=json \
#   int-pki/issue/example-dot-com \
#   common_name="blah.example.com" | tee \
#   >(jq -r .data.ca_chain > cert/client.ca-chain.pem) \
#   >(jq -r .data.certificate > cert/client.crt) \
#   >(jq -r .data.private_key > cert/client.pem) \
#   > /dev/null

# Do truncate CRL
# vault read int-pki/crl/rotate
# vault read root-pki/crl/rotate
