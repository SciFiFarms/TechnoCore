vault_i() {
    docker exec -i $containerId vault "$@"
}

# First argment should be the service name. Examples are "vault", "emq"
create_tls(){
    tlsResponse=$(vault_i write -format=json ca/issue/tls common_name="${1}.${domain}" alt_names="${1}.local,${1}" ttl=720h format=pem)
    tlsCert=$(grep -Eo '"certificate":.*?[^\\]",' <<< "$tlsResponse" | cut -d \" -f 4)
    tlsKey=$(grep -Eo '"private_key":.*?[^\\]",' <<< "$tlsResponse" | cut -d \" -f 4)
    tlsCa=$(grep -Eo '"issuing_ca":.*?[^\\]",' <<< "$tlsResponse" | cut -d \" -f 4)

    if [ $2 ]; then
        docker secret rm "${stackname}_${1}_key"
        docker secret rm "${stackname}_${1}_cert_bundle"
    fi

    echo -e "$tlsKey" | docker secret create "${stackname}_${1}_key" -
    echo -e "${tlsCert}\n${tlsCa}" | docker secret create "${stackname}_${1}_cert_bundle" -
}

create_TLS_certs(){
    # Create TLS certs for services.
    secrets=$(docker secret ls --format "table {{.Name}}")
    echo $secrets
    for service in "${services[@]}"
    do
        # If the secret doesn't exist, create it.
        if [[ ! "$secrets" =~ .*${stackname}_$service.* ]] || [ $reinstall ]; then
            echo "Creating TLS certs for ${stackname}_$service"
            create_tls $service $reinstall
        fi
    done
}

initialize_vault(){
    echo "Initializing Vault"
    # I have to pass in a custom config to start vault without TLS.
    containerId=$(docker run -d -p 8200:8200 --name vault --network $network_name -e "VAULT_CONFIG_DIR=/vault/setup" -e "VAULT_ADDR=http://127.0.0.1:8200" -v ${stackname}_vault:/vault/file allthing/vault)
    sleep 1
    initResponse=$(vault_i operator init -key-shares=1 -key-threshold=1)
    unsealKey=$(grep -C 1 "Unseal Key" <<< "$initResponse" | cut -d : -f 2 | xargs)
    rootToken=$(grep -C 1 "Root Token" <<< "$initResponse" | cut -d : -f 2 | xargs)
    create_secret vault_unseal $unsealKey
    create_secret vault_token $rootToken
    vault_i operator unseal $unsealKey
    vault_i login $rootToken
    vault_i audit enable file file_path=stdout
}

# $1 = policy name. 
create_token(){ 
    vault_i token create -policy=$1 -ttl="720h" -display-name="$1" -field="token"
}

configure_CAs(){
    # Configure root CA
    vault_i secrets enable -path=rootca -description="${stackname} Root CA" -max-lease-ttl=87600h pki
    rootResponse=$(vault_i write rootca/root/generate/internal common_name="${stackname} Root CA" ttl=87600h key_bits=4096 exclude_cn_from_sans=true)
    vault_i write rootca/config/urls issuing_certificates="https://vault.scifi.farm:8200/v1/rootca/ca" crl_distribution_points="https://vault.scifi.farm:8200/v1/rootca/crl" ocsp_servers="https://vault.scifi.farm:8200/v1/rootca/ocsp" 
    caPem=$(curl -s http://127.0.0.1:8200/v1/rootca/ca/pem)
    echo -e "$caPem" > ca.pem

    #Configure intermediate CA
    vault_i secrets enable -path=ca -description="$stackname Ops Intermediate CA" -max-lease-ttl=26280h pki
    csr=$(vault_i write -field=csr ca/intermediate/generate/internal common_name="${stackname} Intermediate CA" alt_names="vault" ip_sans="127.0.0.1" ttl=26280h key_bits=4096 exclude_cn_from_sans=true)
    certResponse=$(vault_i write -field=certificate rootca/root/sign-intermediate csr="$csr" common_name="vault" ttl=8760h format=pem_bundle)
    vault_i write ca/intermediate/set-signed certificate="$(echo -e "$certResponse\n$caPem")"
    vault_i write ca/config/urls issuing_certificates="https://vault.scifi.farm:8200/v1/ca/ca" crl_distribution_points="https://vault.scifi.farm:8200/v1/ca/crl" ocsp_servers="https://vault.scifi.farm:8200/v1/ca/ocsp" 
    vault_i write ca/roles/tls key_bits=2048 max_ttl=8760h allow_any_name=true enforce_hostnames=false
    caIntPem=$(curl -s http://127.0.0.1:8200/v1/ca/ca/pem)

    docker secret rm "${stackname}_ca_bundle"
    echo -e "$caPem\n$caIntPem" | docker secret create "${stackname}_ca_bundle" - 
    docker secret rm "${stackname}_ca"
    echo -e "$caPem" | docker secret create "${stackname}_ca" - 
}

# $1: username/file prefix.
create_vault_user_and_token(){
    vault_i policy write $1 - < vault/${1}_policy.hcl # $mqtt 
    local token=$(create_token $1)
    create_secret ${1}_token  $token
}