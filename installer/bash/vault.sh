vault_i() {
    docker exec -i $containerId vault "$@"
}

# $1: service name. Examples are "vault", "emq"
create_tls(){
    local alt_names="${1}.${domain:-scifi.farm},${1}.local"
    if [ "$1" == "nginx" ]; then
        alt_names="${1}.${domain:-scifi.farm},${1}.local,${stack_name:-technocore},${stack_name:-technocore}.local,${stack_name:-technocore}.${domain:-scifi.farm},${HOSTNAME},${HOSTNAME}.local,${HOSTNAME}.${domain:-scifi.farm}"
    fi
    local tlsResponse=$(vault_i write -format=json ca/issue/tls common_name="${1}" alt_names="$alt_names" ttl=720h format=pem)
    local tlsCert=$(grep -Eo '"certificate":.*?[^\\]",' <<< "$tlsResponse" | cut -d \" -f 4)
    local tlsKey=$(grep -Eo '"private_key":.*?[^\\]",' <<< "$tlsResponse" | cut -d \" -f 4)
    local tlsCa=$(grep -Eo '"issuing_ca":.*?[^\\]",' <<< "$tlsResponse" | cut -d \" -f 4)

    create_secret ${1}_key "$tlsKey"
    create_secret ${1}_cert_bundle "${tlsCert}\n${tlsCa}"
}

# Create TLS certs for services.
create_TLS_certs(){
    local secrets=$(docker secret ls --format "table {{.Name}}")
    for service in "${services[@]}"
    do
            echo "Creating TLS certs for ${stack_name:-technocore}_$service"
            create_tls $service $reinstall
    done
}

configure_CAs(){
    # Configure root CA
    vault_i secrets enable -path=rootca -description="${stack_name:-technocore} Root CA" -max-lease-ttl=87600h pki
    rootResponse=$(vault_i write rootca/root/generate/internal common_name="${stack_name:-technocore} Root CA" ttl=87600h key_bits=4096 exclude_cn_from_sans=true)
    vault_i write rootca/config/urls issuing_certificates="https://vault.scifi.farm:8200/v1/rootca/ca" crl_distribution_points="https://vault.scifi.farm:8200/v1/rootca/crl" ocsp_servers="https://vault.scifi.farm:8200/v1/rootca/ocsp" 
    local caPem=$(curl -s http://127.0.0.1:8200/v1/rootca/ca/pem)
    echo -e "$caPem" > ca.pem

    #Configure intermediate CA
    vault_i secrets enable -path=ca -description="$stack_name Ops Intermediate CA" -max-lease-ttl=26280h pki
    local csr=$(vault_i write -field=csr ca/intermediate/generate/internal common_name="${stack_name:-technocore} Intermediate CA" alt_names="vault" ip_sans="127.0.0.1" ttl=26280h key_bits=4096 exclude_cn_from_sans=true)
    local certResponse=$(vault_i write -field=certificate rootca/root/sign-intermediate csr="$csr" common_name="vault" ttl=8760h format=pem_bundle)
    vault_i write ca/intermediate/set-signed certificate="$(echo -e "$certResponse\n$caPem")"
    vault_i write ca/config/urls issuing_certificates="https://vault.scifi.farm:8200/v1/ca/ca" crl_distribution_points="https://vault.scifi.farm:8200/v1/ca/crl" ocsp_servers="https://vault.scifi.farm:8200/v1/ca/ocsp" 
    vault_i write ca/roles/tls key_bits=2048 max_ttl=8760h allow_any_name=true enforce_hostnames=false
    local caIntPem=$(curl -s http://127.0.0.1:8200/v1/ca/ca/pem)

    create_secret ca_bundle "$caPem\n$caIntPem"
    create_secret ca "$caPem"
}
