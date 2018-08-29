path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/tools/random/*" {
  capabilities = ["read"]
}

path "sys/policy/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}