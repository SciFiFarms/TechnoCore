#!/bin/env bash

# Outputs the composite compose.yml file. 
# Loads all defaults.sh files in ./services/*/
get_compose(){
    # First load the default settings.
    for env in $TECHNOCORE_SERVICES/*/defaults.sh; do
        if [ -f "$env" ]; then
            . $env
        else
            echo "No services to load."
        fi
    done

    # Then load the users .env. This gives priority to the .env settings.
    if [ -f ".env" ]; then
        source .env
    fi

    # Looping like this is prone to issues with whitespaces. I think this case is OK 
    # because the keys have to be single words and I'm not interested in the values. 
    # https://stackoverflow.com/questions/9612090/how-to-loop-through-file-names-returned-by-find
    for config in $(env | grep SERVICE_.*=); do
        env_var=$( echo $config | cut -d "=" -f 1)
        if [ ! -z ${!env_var} ]; then
            included_configs+=" -f ${!env_var}"
        fi
    done

    export HASHED_PASSWORD=$(openssl passwd -apr1 $ADMIN_PASSWORD)
    # TODO: Add 2> $SOME_FLAG or something like that. Want to send to std_out or /dev/null. 
    # Taken from the bottom of https://github.com/docker/cli/issues/939
    docker-compose $included_configs config 
}
