#!/bin/bash

export VAULT_ADDR='http://127.0.0.1:8200'

sh ../server.sh || exit 1

vault secrets enable transit
# -f for force post request when no data
vault write -f transit/keys/example
vault policy write transit-example policy.hcl
vault token create \
  -field=token \
  -policy=transit-example \
  -ttl=1h > transit.token

testtxt=$(base64 <<< "4111 1111 1111 1111")

# Encrypt
vault write -field=ciphertext \
  transit/encrypt/example \
  plaintext=$testtxt \
  > cipher.txt

# Decrypt
vault write -field=plaintext \
  transit/decrypt/example \
  ciphertext=$(cat cipher.txt) \
  > plain-base64.txt

# Rotate
vault write -f transit/keys/example/rotate

# Encrypt v2
vault write -field=ciphertext \
  transit/encrypt/example \
  plaintext=$testtxt \
  > cipher-v2.txt

# Only version 2's key can enc/dec
vault write transit/keys/example/config \
  min_decryption_version=2 \
  min_encryption_version=2

# Decrypt v1 will return error
vault write transit/decrypt/example \
  ciphertext=$(cat cipher.txt)

# Rewrap
vault write transit/keys/example/config min_decryption_version=1
vault write -field=ciphertext \
  transit/rewrap/example \
  ciphertext=$(cat cipher.txt) \
  > cipher-v1tov2.txt

# Trim key (delete version 1)
vault write transit/keys/example/config min_decryption_version=2
vault write transit/keys/example/trim min_available_version=2

# Clean up
: '
vault write transit/keys/example/config deletion_allowed=1
vault delete transit/keys/example
vault secrets disable transit
'