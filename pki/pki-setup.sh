#!/bin/bash

# Root CA
vault secrets enable -path=root-pki pki
vault write root-pki/root/generate/internal \
  common_name="My Root CA" \
  ttl=24h

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
