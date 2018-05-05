storage "file" {
    path = "/vault/file"
}
listener "tcp" {
    address = "127.0.0.1:8209"
    tls_disable = 1
}
listener "tcp" {
    address = "0.0.0.0:8200"
    tls_disable = 0
    tls_cert_file = "/run/secrets/vault_cert"
    tls_key_file = "/run/secrets/vault_key"
    tls_client_ca_file = "/run/secrets/ca.pem"
}
disable_mlock = true