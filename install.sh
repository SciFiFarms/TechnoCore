#!/bin/bash

# Make sure dependencies are met. 
# Source: https://askubuntu.com/questions/15853/how-can-a-script-check-if-its-being-run-as-root
if ! [ $(id -u) = 0 ]; then
   echo "Not running as root. Try running with sudo prepended to the command. "
   exit 1
fi
# Source: https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
if ! command -v docker >/dev/null 2>&1; then
    # TODO: the \n isn't working.
    echo >&2 "Docker is required but not installed. See https://hub.docker.com/search/?type=edition&offering=community \nAborting Install."
    exit 1
fi

# TODO: Add user permission to use docker if not already setup.
#https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/

# Test that for each file in linux(or deb vs rpm) installer folder, there is a corresponding file in the osx and/or windows folder. 
# Check /etc/tls/certs and /etc/tls/keys, and maybe ca-cets and ca-keys. Load them if avalible.
# Maybe /etc/tls/technocore
source .env
reinstall=1

# List of services
declare -a services=(vault home_assistant mqtt home_assistant_db node_red docs platformio portainer nginx)

# Remove old stack if one is found.
if  docker stack ls | grep -w technocore > /dev/null || docker secret ls | grep -w technocore_ca > /dev/null ; then
    echo "Previous $stack_name install detected. "
    if [ -v TECHNOCORE_REINSTALL ]; then
        echo "Removing stack $stack_name"
        docker stack rm $stack_name
        sleep 10
        source utilities/clean.sh
    fi
fi

# Load the installer functions. 
# TODO: Construct the path by figuring out host env and choosing the appropriate folders. 
for file in ./installer/bash/*; do
   source $file
done

add_services_to_hosts_file

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

create_secret home_assistant_mqtt_username "Not yet set."
create_secret home_assistant_mqtt_password "Not yet set."
create_secret node_red_mqtt_username "Not yet set."
create_secret node_red_mqtt_password "Not yet set."
create_secret platformio_mqtt_username "Not yet set."
create_secret platformio_mqtt_password "Not yet set."

create_vault_user_and_token platformio
create_vault_user_and_token portainer
create_vault_user_and_token mqtt


create_TLS_certs

remove_temp_containers
docker network rm $network_name


# Found on: https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
env $(egrep -v '^#' .env | xargs) docker stack deploy --compose-file docker-compose.yml ${stack_name}
# Maybe pull a backup of the CA from docker secrets. Put in /etc/tls/technocore.
# Remove vault port
# docker service update --publish-rm 8200 ${stack_name}_vault
