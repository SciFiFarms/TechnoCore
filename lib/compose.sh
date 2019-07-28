#!/bin/env bash
export LOGGING_DRIVER=${LOGGING_DRIVER:-journald}

# $1: The setting name
# $2: The value to be set
default_to (){
    # This checks that the variable's existence. It WILL detect empty strings as set.
    if [[ ! ${!1} && ${!1-unset} ]]; then
        export $1=$2
    fi
}

# $1: SERVICE_NAME
# $2: The path prefix to set. Eg. prometheus
path_prefix (){
    if [[ "$INGRESS_TYPE" == "subdomain" ]]; then
        #echo "SUBDOMAIN"
        export ${1}_PATH_PREFIX=/
    else
        #echo "PATH_PREFX"
        export ${1//-/_}_PATH_PREFIX=/${2}/
    fi
}

# $1: The service that the credentials are for. 
# The secrets are in the format ${STACK_NAME}_${SERVICE_NAME}_${MOUNT_POINT}
# This takes $SERVICE_NAME and will generate usernames and passwords for any 
# credentials listed in the generated compose file that start with ${STACK_NAME}_${SERVICE_NAME} 
# and end in _username or _password. 
# The exception is if there is an admin username/password. In that case, ${STACK_NAME}_admin... does 
# not get created because there is no admin service.
generate_password_for (){
    local credential_provider=$1
    for secret in $(echo "$COMPLETE_COMPOSE" | yq read - 'secrets.*.name') ;do
        if [ "$secret" = "-" ]; then
            continue
        fi

        # TODO: Add flag to recreate all secrets. Would need to add below... Or just work into secret_exists
        if secret_exists $secret; then
            continue
        fi

        if [[ "$secret" =~ ${STACK_NAME:?STACK_NAME must be set}_${credential_provider}_(.*)_password ]]; then
            local service=${BASH_REMATCH[1]}

            # There isn't an admin service, so don't create a secret for it.
            if [ "$service" = "admin" ]; then continue; fi

            local password=$(generate_password 32)
            create_secret ${credential_provider} ${service}_password "$password"
            create_secret ${service} ${credential_provider}_password "$password"
        fi
    done
}

# $1: Secret to check existence of
secret_exists(){
    docker secret ls | grep -w $secret > /dev/null
}

# $1: The service folder name
# $2: The default setting
set_service_flag (){
    # This one is actually technocore.
    local service_name=${1^^}
    local service_folder=${2:-$1}
    local service_flag=SERVICE_${service_name//-/_}

    # TODO: Could do some logic to detect if $2 suggests a no response. 
    default_to $service_flag $2

    if [[ "${!service_flag}" != "" ]]; then
        config_location=$TECHNOCORE_SERVICES/${service_name,,}/compose.yml
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
            # Get the last folder and make it the default service name.
            service_name=$(dirname $env)
            service_name=${service_name##*/}
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
    docker-compose $included_configs config 
    >&2 echo "Included configs: $included_configs"
}

generate_complete_compose() {
    COMPLETE_COMPOSE=$(get_compose)
    if [[ "$COMPLETE_COMPOSE" == "" ]]; then
        >&2 echo "There was an error generating the compose file. Exiting."
        exit 1;
    fi
}
