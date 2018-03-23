#!/bin/bash
# Test that docker exists.
# Test that your installing as root or sudo. 
# Check /etc/tls/certs and /etc/tls/keys, and maybe ca-cets and ca-keys. Load them if avalible. 
# Maybe /etc/tls/althing
stackname=althing

vault=vault.scifi.farm
ha=ha.scifi.farm
mqtt=mqtt.scifi.farm
ha_db=ha_db.scifi.farm
nr=nr.scifi.farm

# List of services 
declare -a services=($vault $ha $mqtt $ha_db $nr) 
# May have to do the same for all the services.
echo " " | docker secret create althing_vault-cert -
echo " " | docker secret create althing_vault-key -


# Add domains to hosts file.
for service in "${services[@]}"
do
    echo "Adding $service to /etc/hosts."
    if ! grep -q $service /etc/hosts; then
        echo "127.0.0.1 $service" >> /etc/hosts
    fi
done

# Put export uid commands in profiles.d
if [ ! -f /etc/profile.d/docker-uid.sh ]; then
    echo "export UID" >> /etc/profile.d/docker-uid.sh
    chmod +x /etc/profile.d/docker-uid.sh
    export UID
fi

docker-compose build .
docker stack deploy --config-file docker-compose.yaml $stackname


# Add vault port. 
# I don't think I need that if I run commands from docker.
# docker service update --publish-add 8200 althing_vault

secrets=$(docker secret ls --format "table {{.Name}}")
echo $secrets
for service in "${services[@]}"
do
    # If the secret doesn't exist, create it. 
    echo "${stackname}_$service"
    if [[ ! "$secrets" =~ .*${stackname}_$service.* ]]; then
        cert="$service|cert"
        key="$service|key"
        echo "Cert: $cert"
        echo "Key: $key"
        docker exec -it $(docker ps -f name="$stackname" -f ancestor="althing/vault" -q) vault

    fi
done
# Generate certs from within vault. 
# Put CA into browsers or use lets encrypt.
# Maybe pull a backup of the CA from docker secrets. Put in /etc/tls/althing.
# Remove vault port
# docker service update --publish-rm 8200 althing_vault


if [ ! docker volume ls | grep ${stackname}_vault]; then
    docker volume create ${stackname}_vault
    docker run ${stackname}/vault server -config="JSON GOES HERE"
    docker run ${stackname}/vault init
    docker run ${stackname}/vault Gen CA 
    docker run ${stackname}/vault Gen Intermediate 
    docker run ${stackname}/vault Gen vault tls 
fi
