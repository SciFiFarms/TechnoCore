#!/bin/bash


# $1: The username to create
# $2: The service this user is for
function create_mqtt_user()
{
    # TODO: I think there is a programatic way to do this that would allow for 
    # max retries annd sleep time to be passed in as parameters. 
    until local response=$(curl --cacert /run/secrets/ca \
        -H "X-Vault-Token: $(cat /run/secrets/token)" \
        -X POST \
        https://vault:8200/v1/sys/tools/random/32);
    do
        echo "Can't reach Vault, sleeping."
        sleep 5
    done;
    local mqtt_password=$(extract_from_json random_bytes "$response")

    create_secret "$2/mqtt_username" "$1"
    create_secret "$2/mqtt_password" "$mqtt_password"

    mqtt_publish portainer-create_mqtt_user mqtt/add/user/$1 "$mqtt_password"
    #add_user_to_vernemq "$1" "$mqtt_password"
}