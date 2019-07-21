#!/bin/env bash

# $1: The setting name
# $2: The value to be set
default_to (){
    if [ ! ${!1} ]; then
        export $1=$2
    fi
}

# $1: The service folder name
# $2: The default setting
set_service_flag (){
    # This one is actually technocore.
    local service_name=$1
    local service_folder=${2:-$1}
    local service_flag=SERVICE_${service_name/-/_}

    # TODO: Could do some logic to detect if $2 suggests a no response. 
    default_to $service_flag $2

    if [[ "${!service_flag}" ]]; then
        config_location=$TECHNOCORE_SERVICES/${service_name}/compose.yml
        export $service_flag=$config_location
        export SERVICE_CONFIG_${service_name/-/_}=$config_location
    fi
}

# Outputs the composite compose.yml file. 
# Loads all defaults.sh files in ./services/*/
get_compose(){
    # First load the users .env. 
    if [ -f ".env" ]; then
        source .env
    fi

    # Then start setting unset defaults. 
    default_to INGRESS_TYPE subdomain
    for env in $TECHNOCORE_SERVICES/*/defaults.sh; do
        if [ -f "$env" ]; then
            source $env
        else
            echo "No services to load."
        fi
    done


    # Looping like this is prone to issues with whitespaces. I think this case is OK 
    # because the keys have to be single words and I'm not interested in the values. 
    # https://stackoverflow.com/questions/9612090/how-to-loop-through-file-names-returned-by-find
    for config in $(env | grep SERVICE_CONFIG_.*=); do
        env_var=$( echo $config | cut -d "=" -f 1)
        if [ ! -z ${!env_var} ]; then
            included_configs+=" -f ${!env_var}"
        fi
    done

    export HASHED_PASSWORD=$(openssl passwd -apr1 $ADMIN_PASSWORD)
    # TODO: Add 2> $SOME_FLAG or something like that. Want to send to std_out or /dev/null. 
    # Perhaps separate out the generation of included configs from the call to docker-compose.
    # Taken from the bottom of https://github.com/docker/cli/issues/939
    docker-compose $included_configs config 
}
