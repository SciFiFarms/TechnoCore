#!/usr/bin/env bash

# $1: The service this secret is for
# $2: Mount point for the secret. mqtt_username is an example. 
# $3: The secret to store. 
function create_secret()
{
    service_name=$1
    mount_point=$2
    secret_name=${stack_name}_${service_name}_${mount_point}
    secret=$3
    echo "Updating secret ${secret_name}"
    echo -e "$secret" | docker secret create ${secret_name}.temp - > /dev/null
    docker service update --detach=true --secret-rm ${secret_name} --secret-add source=${secret_name}.temp,target=${mount_point} ${stackname}_${service_name} > /dev/null
    docker secret rm ${secret_name} > /dev/null
    echo -e "$secret" | docker secret create ${secret_name} - > /dev/null
    if [ "$service_name" == "home_assistant_db" ] && [ "$mount_point" == "key" ]
    then
        custom_options=",mode=0400,uid=999"
    elif [ "$service_name" == "home_assistant" ] && [ "$mount_point" == "key" ]
    then
        custom_options=",mode=0400"
    else
        custom_options=",mode=0444"
    fi

    docker service update --detach=true --secret-rm ${secret_name}.temp --secret-add source=${secret_name},target=${mount_point}${custom_options} ${stackname}_${service_name} > /dev/null
    docker secret rm ${secret_name}.temp > /dev/null
}