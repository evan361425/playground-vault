#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

sh ../server.sh || exit 1

# Root CA
vault secrets enable -path=root-pki pki
vault write root-pki/root/generate/internal \
  common_name="My Root CA" \
  ttl=24h
# Truncate expired certifciate
vault write root-pki/tidy tidy_revoked_certs=true

# issuing certificate, CRL distribution points, and OCSP server endpoints
# Urls
vault write root-pki/config/urls \
  issuing_certificates="$VAULT_ADDR/v1/root-pki/ca" \
  crl_distribution_points="$VAULT_ADDR/v1/root-pki/crl"

# See configuration
curl -s "$VAULT_ADDR/v1/root-pki/ca/pem" | openssl x509 -text

# Intermediate CA
vault secrets enable -path=int-pki pki
vault write -field=csr \
  int-pki/intermediate/generate/internal \
  common_name="My Intermediate CA" \
  ttl=12h > cert/intermediate.csr
# Truncate expired certifciate
vault write int-pki/tidy tidy_revoked_certs=true

# Get signed CSR from root
vault write -field=certificate \
  root-pki/root/sign-intermediate \
  csr=@cert/intermediate.csr \
  format=pem_bundle \
  ttl=12h > cert/intermediate.crt

# Root CA sign intermediate
vault write int-pki/intermediate/set-signed \
  certificate=@cert/intermediate.crt

# Urls
vault write int-pki/config/urls \
  issuing_certificates="$VAULT_ADDR/v1/int-pki/ca" \
  crl_distribution_points="$VAULT_ADDR/v1/int-pki/crl"

# Set role
vault write int-pki/roles/example-dot-com \
  allowed_domains=example.com \
  allow_subdomains=true \
  allow_glob_domains=true \
  generate_lease=true \
  max_ttl=1m \
  ttl=1m

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
# vault read intermediate-pki/crl/rotate
# vault read root-pki/crl/rotate
