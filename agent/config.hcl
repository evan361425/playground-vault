pid_file = ".pidfile"

vault {
  address = "http://127.0.0.1:8200"
  client_cert = "cert/client.crt"
  client_key = "cert/client.pem"
  tls_server_name = "blah.example.com"
}

auto_auth {
  method approle {
    mount_path = "auth/approle"

    config {
      role_id_file_path = "src/role.id"
      secret_id_file_path = "src/secret.id"
      remove_secret_id_file_after_reading = false # Avoiding always rebuild secret
    }
  }

  sink file {
    wrap_ttl = "5m"
    config = {
      path = "sink.txt"
    }
  }
}

listener tcp {
  address = "127.0.0.1:8300"
  tls_disable = true
}

template {
  source      = "src/certificate.tpl"
  destination = "cert/client.crt"
}

template {
  source      = "src/key.tpl"
  destination = "cert/client.pem"
}
