#!/usr/bin/env bash

# $1: The number of characters to generate.
generate_password(){
    # Inspired from https://raymii.org/s/snippets/OpenSSL_Password_Generator.html
    openssl rand -base64 $1
}

# $1: The service this secret is for
# $2: Mount point for the secret. mqtt_username is an example. 
# $3: The secret to store. 
function create_existing_secret()
{
    local service_name=$1
    local mount_point=$2
    local secret_name=${STACK_NAME}_${service_name}_${mount_point}
    local secret=$3
    echo "Updating secret ${secret_name}"
    echo -e "$secret" | docker secret create ${secret_name}.temp - > /dev/null
    docker service update --detach=true --secret-rm ${secret_name} --secret-add source=${secret_name}.temp,target=${mount_point} ${STACK_NAME}_${service_name} > /dev/null
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

    docker service update --detach=true --secret-rm ${secret_name}.temp --secret-add source=${secret_name},target=${mount_point}${custom_options} ${STACK_NAME}_${service_name} > /dev/null
    docker secret rm ${secret_name}.temp > /dev/null
}

# $1: The service this secret is for
# $2: Mount point for the secret. mqtt_username is an example. 
# $3: The secret to store. 
create_secret(){
    local service_name=$1
    local mount_point=$2
    local secret_name=${STACK_NAME}_${service_name}_${mount_point}
    local secret=$3

    # If the secret exists, we'll have to do a lot more to swap it out.
    if docker secret ls | grep -w $secret_name > /dev/null; then
        if docker service ls | grep -w ${STACK_NAME}_$service_name > /dev/null; then
            echo "Updated existing secret $secret_name"
            create_existing_secret $@
        else
            echo "Updated existing secret without service $secret_name"
            docker secret rm $secret_name
            echo -e "$secret" | docker secret create ${secret_name} - > /dev/null
        fi
    else
        echo "Created new secret $secret_name"
        echo -e "$secret" | docker secret create ${secret_name} - > /dev/null
    fi
}
