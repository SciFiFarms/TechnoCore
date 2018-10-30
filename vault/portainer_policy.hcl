path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "rabbitmq/creds/portainer" {
  capabilities = ["read"]
}

path "sys/policy/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}