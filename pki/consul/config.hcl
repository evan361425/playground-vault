vault {
  address = "http://127.0.0.1:8200"
  vault_agent_token_file = "../pki.token"
  renew_token = true

  retry {
    attempts = 1
    backoff = "250ms"
  }
}

// log_level = "debug"

template {
  source      = "certificate.tpl"
  destination = "client.crt"
  command     = "echo generate certificate!"
}

template {
  source      = "key.tpl"
  destination = "client.pem"
  command     = "echo generate key!"
}
