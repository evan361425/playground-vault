# Intermediate CA issue you!
path "int-pki/issue/example-dot-com" {
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
