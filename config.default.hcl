storage mysql {
  address = "127.0.0.1:3306"
  database = "playground"
  table = "vault"
  username = "root"
  password = "mysql-password"
  plaintext_connection_allowed = true
  ha_enabled = true
}

listener tcp {
  tls_disable = true
  address =  "127.0.0.1:8200"
  cluster_address = "127.0.0.1:8201"
}

ui = true
disable_mlock = true
api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
