#!/bin/bash

vault mount -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int # That's 5 years. 

vault write pki_int/intermediate/generate/internal common_name="myvault.com Intermediate Authority" ttl=43800h
vault write pki/root/sign-intermediate csr=@pki_int.csr format=pem_bundle

vault write pki_int/intermediate/set-signed certificate=@signed_certificate.pem
vault write pki_int/config/urls issuing_certificates="http://127.0.0.1:8200/v1/pki_int/ca" crl_distribution_points="http://127.0.0.1:8200/v1/pki_int/crl"
vault write pki_int/roles/example-dot-com \
    allowed_domains=example.com \
    allow_subdomains=true max_ttl=72h

vault write pki_int/issue/example-dot-com \
    common_name=blah.example.com    