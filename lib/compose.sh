#!/bin/env bash
export LOGGING_DRIVER=${LOGGING_DRIVER:-json-file}
# Could alternatively use ./empty:/opt/.dummy
export EMPTY_MOUNT=/dev/null:/dev/null

# $1: The setting name
# $2: The value to be set
default_to (){
    # This checks that the variable's existence. It WILL detect empty strings as set.
    if [[ ! ${!1} && ${!1-unset} ]]; then
        export $1=$2
    fi
}

# Uppercases and turns '-'s and ' ' into '_'s. an example-name => AN_EXAMPLE_NAME
# $1: The string to convert
bashify (){
    local string=${1^^}
    string=${string//\//_}
    string=${string// /_}
    string=${string//\./_}
    echo "${string//-/_}"
}

# $1: Type of mount: dev | live
# $2: The path to mount (from services dir)
# $3: The path to mount in the container.
function generate_mount() {
    mount_type=$(bashify $1)

    env_var=$(bashify $1)_MOUNT_$(bashify $service_name)_$(bashify $2)
    env_var_enabled=${env_var}_ENABLED

    if [[ "${!env_var_enabled}" != "" ]]; then
        export $env_var="$HOST_SERVICES_DIR/$service_name/$2:$3"
    fi
}

# $1: service-name (folder name in services/...)
# $2: The path prefix to set. Eg. prometheus
path_prefix (){
    local service_name=${1^^}
    service_name=${service_name//-/_}
    if [[ "$INGRESS_TYPE" == "subdomain" ]]; then
        #echo "SUBDOMAIN"
        export ${service_name}_PATH_PREFIX=/
    else
        #echo "PATH_PREFX"
        export ${service_name}_PATH_PREFIX=/${2}/
    fi
}

# $1: The service that the credentials are for. 
# $2: (Optional) The password to set. 
#     This option probably won't be used in production, but is handy for developing and testing.
#     If it presents any trouble, it should be removed.
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

            if [ -z $2 ]; then
                local password=$(generate_password 32)
                create_secret ${credential_provider} ${service}_password "$password"
                create_secret ${service} ${credential_provider}_password "$password"
            else
                create_secret ${credential_provider} ${service}_password "$2"
                create_secret ${service} ${credential_provider}_password "$2"
            fi
            DOCKER_SECRETS=$(docker secret ls)
        fi
    done
}

# $1: Secret to check existence of
secret_exists(){
    echo "$DOCKER_SECRETS" | grep -w $secret > /dev/null
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
        export "SERVICE_CONFIG_${service_name//-/_}=$config_location"
    fi
}

# Adds extra configuration for specific services set by $1
# $1: Service name
set_optional_service (){
    current_service_var=SERVICE_$(bashify ${service_name})
    service_var=SERVICE_$(bashify $1)
    #echo "Exporting optional service: $service_var=${!service_var}" >&2
    if [ ! -z "${!service_var}" ] && [ ! -z "${!current_service_var}" ] ; then
        export SERVICE_CONFIG_$(bashify ${service_name}_$1)=${TECHNOCORE_SERVICES}/$service_name/$1.yml
    fi
}

# $1: service-name (folder name in services/...)
# $2: subdomain or path prefix (no slashes)
generate_domain_list(){
    local env_var=${1^^}
    env_var=${env_var//-/_}_ROUTING_LABEL
    local prefix=${2:?Need second argument for generate_domain_list}

    # TODO: This can be used to update with traefik 2.0 format. 
    # local routing_value=$(echo "Host(\`${prefix}.$DOMAIN\`)")
    local routing_value=$(echo "Host:${prefix}.$DOMAIN")

    # This will need to be updated when using traefik 2.0. 
    for domain in $(echo $EXTRA_DOMAINS | tr "," "\t"); do
        routing_value=${routing_value},${prefix}.$domain
    done

    # Counting the length of the rule will keep it consistent with how Traefik works.
    export ${env_var}_PRIORITY=$(echo $routing_value | wc -c)

    if [ "$DEFAULT_SERVICE" = "$1" ]; then
        routing_value="${routing_value},$DOMAIN,$EXTRA_DOMAINS"
        # 1 is the lowest priority. This way, the plain domain gets picked only 
        # if no other domains get matched.
        export ${env_var}_PRIORITY="1"
    fi

    export $env_var=$routing_value
}

# $1: service-name (folder name in services/...)
set_debugging(){
    local env_var
    env_var=DEBUG_$(bashify $1)
    # If $STACK_DEBUG is not set, this will remain the case. 
    export "${env_var}=${!env_var:-$STACK_DEBUG}"
}

# Outputs the composite compose.yml file. 
# Loads all defaults.sh files in ./services/*/
get_compose(){

    # Then start setting unset defaults. 
    default_to INGRESS_TYPE subdomain

    # These are set by default, but each service can override. 
    local service_name=
    local prefix=
    for env in $TECHNOCORE_SERVICES/*/defaults.sh; do
        if [ -f "$env" ]; then
            # Get the last folder and make it the default service name.
            service_name=$(dirname $env)
            service_name=${service_name##*/}
            prefix=$service_name

            # TODO: Have this reference an x-arg in the compose file rather than 
            # running a script. 
            # This allows for the service to override service names or path prefixes.
            source $env
            path_prefix $service_name $prefix
            generate_domain_list $service_name $prefix
            set_debugging $service_name 

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

    # Using 2> /dev/null to hide warnings that docker-compose doesn't support deploy. That's expected 
    # as swarm/deploy isn't used until later in the process, so I hid the error. 
    # If the command fails (denoted by || ), then rerun and actually show the error. 
    docker-compose $included_configs config 2> /dev/null || docker-compose $included_configs config 
}

generate_complete_compose() {
    DOCKER_SECRETS=$(docker secret ls)
    COMPLETE_COMPOSE=$(get_compose)
    if [[ "$COMPLETE_COMPOSE" == "" ]]; then
        >&2 echo "There was an error generating the compose file. Exiting."
        exit 1;
    fi
}
