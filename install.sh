#!/bin/bash
# Test that docker exists.
# Test that your installing as root or sudo.
# Test that for each file in linux(or deb vs rpm) installer folder, there is a corresponding file in the osx and/or windows folder. 
# Check /etc/tls/certs and /etc/tls/keys, and maybe ca-cets and ca-keys. Load them if avalible.
# Maybe /etc/tls/althing
stackname=althing_dev
domain=scifi.farm
reinstall=1

# List of services
vault=vault
ha=ha
mqtt=mqtt
ha_db=ha_db
nr=nr
platformio=platformio
docs=docs
declare -a services=($vault $ha $mqtt $ha_db $nr $docs $platformio)

# Todo: only do this if not inited already.
# I had to use  --advertise-addr 192.168.1.106. I imagine the IP address would change. 
# I also had to install docker-compose seperaately. 
#docker swarm init
#docker swarm join localhost

# TODO: Should check that the stack is up before bringing it down.
if [ $reinstall -eq 1 ] ; then
    docker stack rm $stackname
    sleep 10
    source clean.sh
fi

# Load the installer functions. 
# TODO: Construct the path by figuring out host env and choosing the appropriate folders. 
for file in ./installer/bash/*; do
   source $file
done

add_althing_services_to_hosts_file
export_UID_to_env

network_name="${stackname}"
docker network create --attachable $network_name

if volume_exists vault && [ $reinstall -ne 1 ] ; then
    echo "Vault Initialized";
else
    create_volume vault
    initialize_vault
    configure_CAs
    # In ubuntu, that needs to install libnss3-tools, which provides certutil
    add_CA_to_firefox
fi

if volume_exists mqtt && [ $reinstall -ne 1 ] ; then
    echo "MQTT Initialized";
else
    create_volume mqtt
    initialize_mqtt
    create_vault_and_mqtt_user home_assistant
    create_vault_and_mqtt_user node_red
    create_vault_and_mqtt_user platformio
    platformio_token=$(create_token platformio)
    create_secret platformio_token  $platformio_token
fi

create_TLS_certs

remove_temp_containers
docker network rm $network_name

env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy --compose-file docker-compose.yml $stackname

# TODO: Make this check every # of seconds until it works. 
sleep 30
docker exec -it $(docker service ps -f desired-state=running --no-trunc althing_dev_vault | grep althing_dev | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc althing_dev_vault | grep althing_dev | tr -s " " | cut -d " " -f 1) vault login $rootToken

# TODO: This should actually verify the connection. It seems like the CA cert might not be getting passed into rabbithole. It's also possible that the MQTT service wasn't up yet.
# This page had the code that showed what was going on for varification... Just creating a connection: https://github.com/hashicorp/vault/blob/e2bb2ec3b93a242a167f763684f93df867bb253d/builtin/logical/rabbitmq/path_config_connection.go
# https://github.com/michaelklishin/rabbit-hole
# https://github.com/hashicorp/vault/blob/e2bb2ec3b93a242a167f763684f93df867bb253d/builtin/logical/rabbitmq/secret_creds.go
# https://github.com/hashicorp/vault/blob/e2bb2ec3b93a242a167f763684f93df867bb253d/builtin/logical/rabbitmq/path_role_create.go
docker exec -it $(docker service ps -f desired-state=running --no-trunc althing_dev_vault | grep althing_dev | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc althing_dev_vault | grep althing_dev | tr -s " " | cut -d " " -f 1) vault write rabbitmq/config/connection \
    connection_uri="https://mqtt:15672" \
    username="vault" \
    password="$mqtt_password" \
    verify_connection="false" # Description: If set, connection_uri is verified by actually connecting to the RabbitMQ management API. This simply allows us to set the connection without the server having to be up. 

# Maybe pull a backup of the CA from docker secrets. Put in /etc/tls/althing.
# Remove vault port
# docker service update --publish-rm 8200 althing_vault
