#!/bin/bash
# Set env vars. 
if [ -f ".env" ]; then
source .env
fi
source utilities/aliases.sh
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
    echo -e >&2 "Docker is required but not installed. Installing." 
    echo -e >&2 "To quit and not install docker press ^-C"
    curl -fsSL get.docker.com | CHANNEL=stable sh > $debug_output
    systemctl enable docker > $debug_output
    systemctl start docker > $debug_output
fi

# Add user permission to use docker if not already setup.
# https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/
if getent group docker | grep -w "$USER" > /dev/null ; then
    # Used logname to get username before sudo: https://stackoverflow.com/questions/4598001/how-do-you-find-the-original-user-through-multiple-sudo-and-su-commands
    echo "Adding $(logname) to docker group"
    usermod -a -G docker $(logname)
fi

# Initialize the swarm if it isn't setup.
# Used 2>&1 to include stderr in the pipe to grep as that is where the "Error reponse" 
# would come from. See the following for more about redirection: https://stackoverflow.com/questions/2342826/how-to-pipe-stderr-and-not-stdout
if docker swarm ca 2>&1 | grep "Error response" &> /dev/null ; then
    echo "Initializing Docker Swarm"
    docker swarm init > /dev/null
fi

add_aliases_if_missing()
{
    local alias_path="$(pwd)/utilities/aliases.sh"
    local home_folder="$(getent passwd $SUDO_USER | cut -d: -f6)"
    if ! grep -Fq "$alias_path" ${home_folder}/.bashrc ; then
        echo "source $alias_path" >> ${home_folder}/.bashrc
        echo "Added source $alias_path to ${home_folder}/.bashrc"
    #else
    #    echo "aliases.sh was present in ${home_folder}/.bashrc, skipping addition."
    fi
}
add_aliases_if_missing

# List of services that need TLS.
# This list is duplicated in portainer/mqtt-scripts/renew-tls.sh. 
declare -a services=(vault home_assistant mqtt home_assistant_db node_red docs portainer nginx jupyter grafana loki health timeseries_db )

# Remove old stack if one is found.
if  docker stack ls | grep -w technocore > /dev/null || docker secret ls | grep -w technocore_ca > /dev/null ; then
    echo "Previous ${stack_name:-technocore} install detected. "
        echo "Removing stack ${stack_name:-technocore}"
        source utilities/clean.sh
    fi

# Load the installer functions. 
for file in ./installer/bash/*; do
   source $file
done

network_name="${stack_name:-technocore}"
docker network create --attachable $network_name > /dev/null

# Setup certificate Authorities.
create_volume vault
initialize_vault
configure_CAs
# In ubuntu, that needs to install libnss3-tools, which provides certutil
# TODO: Would like to install LetsEncrypt's testing server CAs. 
add_CA_to_firefox

create_mqtt_user mqtt
create_mqtt_user portainer

# TODO: This could be generated from the docker-compose file at install time
create_secret home_assistant_mqtt_username "Not yet set."
create_secret home_assistant_mqtt_password "Not yet set."
create_secret node_red_mqtt_username "Not yet set."
create_secret node_red_mqtt_password "Not yet set."
create_secret esphome_mqtt_username "Not yet set."
create_secret esphome_mqtt_password "Not yet set."
create_secret portainer_acme_env "Not yet set."

# If any of these need to change, you'll also need to update influxdb with the 
# new usernames and passwords. They are ignored after the DB is initialized.
create_secret timeseries_db_admin_username "Not yet set."
create_secret timeseries_db_admin_password "Not yet set."
create_secret timeseries_db_grafana_username "Not yet set."
create_secret timeseries_db_grafana_password "Not yet set."
create_secret timeseries_db_home_assistant_username "Not yet set."
create_secret timeseries_db_home_assistant_password "Not yet set."

create_secret grafana_timeseries_db_username "Not yet set."
create_secret grafana_timeseries_db_password "Not yet set."
create_secret home_assistant_timeseries_db_username "Not yet set."
create_secret home_assistant_timeseries_db_password "Not yet set."

create_secret nextcloud_exporter_url "Not yet set."
create_secret nextcloud_exporter_password "Not yet set."
create_secret nextcloud_exporter_username "Not yet set."

# TODO: Make an actual flag for dev mode. --dev. 
if [ $# -eq 1 ]; then
    hostname_trimmed=$(echo ${HOSTNAME} | cut -d"." -f 1)
    create_secret home_assistant_domain "$hostname_trimmed"
    create_secret esphome_domain "$hostname_trimmed"
    create_secret grafana_domain "$hostname_trimmed"
    create_secret health_domain "$hostname_trimmed"
else
    create_secret home_assistant_domain "Not yet set."
    create_secret esphome_domain "Not yet set."
    create_secret grafana_domain "Not yet set."
    create_secret health_domain "Not yet set."
fi

create_vault_user_and_token esphome
create_vault_user_and_token portainer
create_vault_user_and_token mqtt

create_TLS_certs

remove_temp_containers
docker network rm $network_name > /dev/null

# Found on: https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
# TODO: This is duplicated in utilities/aliases.sh
if [ -f ".env" ]; then
env $(egrep -v '^#' .env | xargs) docker stack deploy --compose-file docker-compose.yml ${stack_name:-technocore}
else
    docker stack deploy --compose-file docker-compose.yml ${stack_name:-technocore}
    echo "Doesn't have .env"
fi

echo "${stack_name:-technocore} initializing. "

# TODO: This should be parsed in via a flag rather than just assuming the second 
# variable is the development flag. 
if [ $# -eq 0 ]; then
    sleep 1
    # TODO: I'd rather silence errors from the gen-tls.sh command, but 2> doesn't seem to work. 
    until run_portainer gen-tls.sh 
    do
        echo "Waiting for portainer to initialize."
        sleep 5
    done
    until domain=$(run_portainer get-domain.sh 2> /dev/null)
    do
        echo "Waiting for acme.sh to initialize."
        sleep 5
    done
    # This doesn't seem like it should work?
    hostname_trimmed=${domain:-local}
    echo "acme.sh initialized."
fi
# For more about --fail, see: https://superuser.com/questions/590099/can-i-make-curl-fail-with-an-exitcode-different-than-0-if-the-http-status-code-i 
until curl --insecure --fail https://${hostname_trimmed}/ &> /dev/null
do
    echo "https://${hostname_trimmed}/ is not yet up. Will retry in 5 seconds."
    sleep 5
done
echo -e "\n\n\nFinished initializing ${stack_name:-technocore}."
echo "You may now use https://${hostname_trimmed}/ to access your ${stack_name:-technocore} instance."
