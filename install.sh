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
portainer=portainer
declare -a services=($vault $ha $mqtt $ha_db $nr $docs $platformio $portainer)

# Todo: only do this if not inited already.
# I had to use  --advertise-addr 192.168.1.106. I imagine the IP address would change. 
# I also had to install docker-compose seperaately. 
#docker swarm init
#docker swarm join localhost

if [ $reinstall -eq 1 ] ; then
    if docker stack rm $stackname ; then
        echo "$stackname being removed. Sleeping."
    sleep 10
    fi
    source clean.sh
fi

# Load the installer functions. 
# TODO: Construct the path by figuring out host env and choosing the appropriate folders. 
for file in ./installer/bash/*; do
   source $file
done

add_althing_services_to_hosts_file

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
    create_vault_and_mqtt_user portainer
    create_vault_and_mqtt_user mqtt
    platformio_token=$(create_token platformio)
    create_secret platformio_token  $platformio_token
    mqtt_token=$(create_token mqtt)
    create_secret mqtt_token  $mqtt_token
    portainer_token=$(create_token portainer)
    create_secret portainer_token  $portainer_token
fi

create_TLS_certs

remove_temp_containers
docker network rm $network_name

env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy --compose-file docker-compose.yml $stackname

# Maybe pull a backup of the CA from docker secrets. Put in /etc/tls/althing.
# Remove vault port
# docker service update --publish-rm 8200 althing_vault
