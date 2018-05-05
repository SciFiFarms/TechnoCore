#!/bin/bash
# Test that docker exists.
# Test that your installing as root or sudo.
# Check /etc/tls/certs and /etc/tls/keys, and maybe ca-cets and ca-keys. Load them if avalible.
# Maybe /etc/tls/althing
stackname=althing_dev
domain=scifi.farm
forceUpdate=1

# List of services
vault=vault
ha=ha
mqtt=mqtt
ha_db=ha_db
nr=nr
declare -a services=($vault $ha $mqtt $ha_db $nr)

# Add domains to hosts file.
for service in "${services[@]}"
do
    if ! grep -q $service.$domain /etc/hosts; then
        echo "Adding $service.$domain to /etc/hosts."
        echo "127.0.0.1 ${service}.$domain" >> /etc/hosts
    fi
done

# Make profile.d dir first
mkdir -p /etc/profile.d

# Put export uid commands in profiles.d
if [ ! -f /etc/profile.d/docker-uid.sh ]; then
    echo "export UID" >> /etc/profile.d/docker-uid.sh
    chmod +x /etc/profile.d/docker-uid.sh
    export UID
fi

# Build docker images
docker-compose build

vaultConfig='
    {
        "disable_mlock": 1,
        "storage": {
            "file": {
                "path": "/vault/file"
            }
        },
        "listener": {
            "tcp": {
                "address": "0.0.0.0:8200",
                "tls_disable": 1
            }
        }
    }
'
vault_i() {
    docker exec $containerId vault "$@"
}
# First argment should be the service name. Examples are "vault", "emq"
create_tls(){
    tlsResponse=$(vault_i write -format=json ca/issue/tls common_name="${1}.${stackname}.local" ttl=720h format=pem)
    tlsCert=$(grep -Eo '"certificate":.*?[^\\]",' <<< "$tlsResponse" | cut -d \" -f 4)
    tlsKey=$(grep -Eo '"private_key":.*?[^\\]",' <<< "$tlsResponse" | cut -d \" -f 4)
    tlsCa=$(grep -Eo '"issuing_ca":.*?[^\\]",' <<< "$tlsResponse" | cut -d \" -f 4)

    if [ $2 ]; then
        docker secret rm "${stackname}_${1}_cert"
        docker secret rm "${stackname}_${1}_key"
        docker secret rm "${stackname}_${1}_pem"
    fi

    echo -e "$tlsCert" | docker secret create "${stackname}_${1}_cert" -
    echo -e "$tlsKey" | docker secret create "${stackname}_${1}_key" -
    echo -e "${tlsCert}${tlsCa}${caPem}" | docker secret create "${stackname}_${1}_pem" -
}


# Initilize Vault
# I have to pass in a custom config to start vault without TLS.
echo $(docker volume ls | grep ${stackname}_vault)
if [[ ! $(docker volume ls | grep -Fq ${stackname}_vault) == '' ]] ; then
    echo "Vault Initialized";
else
    echo "Initializing Vault"
    docker volume create ${stackname}_vault
    containerId=$(docker run -d -p 8200:8200 -e "VAULT_LOCAL_CONFIG=$vaultConfig" -e "VAULT_ADDR=http://127.0.0.1:8200" -v ${stackname}_vault:/vault/file althing/vault)
    sleep 1
    initResponse=$(vault_i operator init -key-shares=1 -key-threshold=1)
    unsealKey=$(grep -C 1 "Unseal Key" <<< "$initResponse" | cut -d : -f 2 | xargs)
    rootToken=$(grep -C 1 "Root Token" <<< "$initResponse" | cut -d : -f 2 | xargs)
    vault_i operator unseal $unsealKey
    vault_i login $rootToken
    vault_i secrets enable -path=rootca -description="${stackname} Root CA" -max-lease-ttl=87600h pki
    rootResponse=$(vault_i write rootca/root/generate/internal common_name="${stackname} Root CA" ttl=87600h key_bits=4096 exclude_cn_from_sans=true)
    vault_i write rootca/config/urls issuing_certificates="https://127.0.0.1:8200/v1/rootca/ca" crl_distribution_points="https://127.0.0.1:8200/v1/ca/crl"
    vault_i secrets enable -path=ca -description="$stackname Ops Intermediate CA" -max-lease-ttl=26280h pki
    csr=$(vault_i write -field=csr ca/intermediate/generate/internal common_name="$stackname Operations Intermediate CA" ttl=26280h key_bits=4096 exclude_cn_from_sans=true)
    certResponse=$(vault_i write -field=certificate rootca/root/sign-intermediate csr="$csr" common_name="$stackname Intermediate CA" ttl=8760h format=pem_bundle)
    vault_i write ca/intermediate/set-signed certificate="$certResponse"
    vault_i write ca/config/urls issuing_certificates="https://127.0.0.1:8200/v1/ca/ca" crl_distribution_points="https://127.0.0.1:8200/v1/ca/crl"
    vault_i write ca/roles/tls key_bits=2048 max_ttl=8760h allow_any_name=true enforce_hostnames=false
    caPem=$(curl -s http://127.0.0.1:8200/v1/rootca/ca/pem)
    docker secret rm "${stackname}_ca"
    docker secret create "${stackname}_ca" - <<< $caPem
fi

# Create TLS certs for services.
secrets=$(docker secret ls --format "table {{.Name}}")
echo $secrets
for service in "${services[@]}"
do
    # If the secret doesn't exist, create it.
    if [[ ! "$secrets" =~ .*${stackname}_$service.* ]] || [ $forceUpdate ]; then
        echo "Creating TLS certs for ${stackname}_$service"
        create_tls $service $forceUpdate
    fi
done

# Remove the temperary vault container.
if [ $containerId ]; then
    docker stop $containerId
    docker rm $containerId
fi

docker stack deploy --compose-file docker-compose.yml $stackname

# I'm pretty sure I'll need to do something with the unseal key every reboot. Put it in the vault entry script.
# Put CA into browsers or use lets encrypt.
# Maybe pull a backup of the CA from docker secrets. Put in /etc/tls/althing.
# Remove vault port
# docker service update --publish-rm 8200 althing_vault
