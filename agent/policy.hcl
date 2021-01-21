# Intermediate CA issue you!
path "int-pki/issue/*" {
  "capabilities" = ["create", "update"]
}

# Root CA verify cert!
path "root-pki/cert/ca" {
  "capabilities" = ["read"]
}

# Token
path "auth/token/renew" {
  "capabilities" = ["update"]
}
path "auth/token/renew-self" {
  "capabilities" = ["update"]
}

# Some secrets
path "playground/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "playground/exist/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
