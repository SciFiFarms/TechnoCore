#!/bin/bash
# Set env vars. 
source .env
TECHNOCORE_REINSTALL=1
# TODO: Replace all the /dev/nulls in install.sh, vault.sh, and host.sh (Other places?). This should really be set in .env.
debug_output=/dev/null

# Make sure dependencies are met. 
# Source: https://askubuntu.com/questions/15853/how-can-a-script-check-if-its-being-run-as-root
if ! [ $(id -u) = 0 ]; then
   echo "Not running as root. Try running with sudo prepended to the command. "
   exit 1
fi
# Source: https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
if ! command -v docker >/dev/null 2>&1; then
    echo -e >&2 "Docker is required but not installed. See https://hub.docker.com/search/?type=edition&offering=community \nAborting Install."
    exit 1
fi

# Add user permission to use docker if not already setup.
#https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/
if ! getent group docker | grep -w "$USER" > /dev/null ; then
    # Used logname to get username before sudo: https://stackoverflow.com/questions/4598001/how-do-you-find-the-original-user-through-multiple-sudo-and-su-commands
    echo "Adding $(logname) to docker group"
    usermod -a -G docker $(logname)
fi

# Initialize the swarm if it isn't setup.
if docker swarm ca | grep "Error response" &> /dev/null ; then
    echo "Initializing Docker Swarm"
    docker swarm init
fi

# List of services that need TLS.
declare -a services=(vault home_assistant mqtt home_assistant_db node_red docs portainer nginx)

# Remove old stack if one is found.
if  docker stack ls | grep -w technocore > /dev/null || docker secret ls | grep -w technocore_ca > /dev/null ; then
    echo "Previous $stack_name install detected. "
    if [ -v TECHNOCORE_REINSTALL ]; then
        echo "Removing stack $stack_name"
        source utilities/clean.sh
    fi
fi

# Load the installer functions. 
for file in ./installer/bash/*; do
   source $file
done

network_name="${stack_name}"
docker network create --attachable $network_name > /dev/null

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
create_secret esphomeyaml_mqtt_username "Not yet set."
create_secret esphomeyaml_mqtt_password "Not yet set."

create_vault_user_and_token esphomeyaml
create_vault_user_and_token portainer
create_vault_user_and_token mqtt

create_TLS_certs

remove_temp_containers
docker network rm $network_name > /dev/null

# Found on: https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
env $(egrep -v '^#' .env | xargs) docker stack deploy --compose-file docker-compose.yml ${stack_name}

echo "${stack_name} initializing. "
# For more about --fail, see: https://superuser.com/questions/590099/can-i-make-curl-fail-with-an-exitcode-different-than-0-if-the-http-status-code-i 
until curl --insecure --fail https://${HOSTNAME}/ &> /dev/null
do
    echo "https://${HOSTNAME}/ is not yet up. Will retry in 5 seconds."
    sleep 5
done
echo -e "\n\n\nFinished initializing ${stack_name}."
echo "You may now use https://${HOSTNAME}/ to access your ${stack_name} instance."
