#!/bin/bash
# Test that docker exists.
# Test that your installing as root or sudo.
# Test that for each file in linux(or deb vs rpm) installer folder, there is a corresponding file in the osx and/or windows folder. 
# Check /etc/tls/certs and /etc/tls/keys, and maybe ca-cets and ca-keys. Load them if avalible.
# Maybe /etc/tls/technocore
stack_name=technocore
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
    if docker stack rm $stack_name ; then
        echo "$stack_name being removed. Sleeping."
        sleep 10
    fi
    source utilities/clean.sh
fi

# Load the installer functions. 
# TODO: Construct the path by figuring out host env and choosing the appropriate folders. 
for file in ./installer/bash/*; do
   source $file
done

add_althing_services_to_hosts_file

network_name="${stack_name}"
docker network create --attachable $network_name

# Setup certificate Authorities.
create_volume vault
initialize_vault
configure_CAs
# In ubuntu, that needs to install libnss3-tools, which provides certutil
add_CA_to_firefox

create_mqtt_user mqtt
create_mqtt_user portainer

create_vault_user_and_token platformio
create_vault_user_and_token portainer
create_vault_user_and_token mqtt


create_TLS_certs

remove_temp_containers
docker network rm $network_name

env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy --compose-file docker-compose.yml $stack_name

# Maybe pull a backup of the CA from docker secrets. Put in /etc/tls/technocore.
# Remove vault port
# docker service update --publish-rm 8200 ${stack_name}_vault
