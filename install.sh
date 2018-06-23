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
declare -a services=($vault $ha $mqtt $ha_db $nr)

# Todo: only do this if not inited already.
# I had to use  --advertise-addr 192.168.1.106. I imagine the IP address would change. 
# I also had to install docker-compose seperaately. 
#docker swarm init
#docker swarm join localhost

# TODO: Should check that the stack is up before bringing it down.
if [ $reinstall -eq 1 ] ; then
    docker stack rm $stackname
    sleep 10
fi

# Load the installer functions. 
# TODO: Construct the path by figuring out host env and choosing the appropriate folders. 
for file in ./installer/bash/*; do
   source $file
done

add_althing_services_to_hosts_file
export_UID_to_env

# Build docker images
docker-compose build

docker network create $stackname

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
fi

if volume_exists ha_db && [ $reinstall -ne 1 ] ; then
    echo "Home Assistant database Initialized";
else
    create_volume ha_db
    initialize_ha_db
fi

create_TLS_certs

remove_temp_containers
docker network rm $stackname

docker stack deploy --compose-file docker-compose.yml $stackname


# Maybe pull a backup of the CA from docker secrets. Put in /etc/tls/althing.
# Remove vault port
# docker service update --publish-rm 8200 althing_vault
