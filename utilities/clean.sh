#!/bin/bash

# TODO: I doubt this works.
technocore_folder=$(cd $(dirname $0) && pwd/..)
source ${technocore_folder}/.env 

remove_volume() {
    local response # Declare response as a local var.
    until response=$(docker volume rm $1 2>&1)
    do 
        #echo "$response"
        if grep -q 'No such volume' <<< $response; then
            echo "Volume $1 doesn't exist, so it won't be removed."
            break
        fi
        if grep -q 'volume is in use' <<< $response; then
            local container=$(echo "$response" | cut -d"[" -f2 | cut -d"]" -f1 )
            echo "Volume is in use by container $container. Will stop."
            docker rm -f $container
        fi
        sleep 2
    done
    echo "Removed volume $1."
}

remove_volume ${stack_name}_home-assistant-db 
remove_volume ${stack_name}_home-assistant-db-migrations
remove_volume ${stack_name}_node-red
remove_volume ${stack_name}_portainer
remove_volume ${stack_name}_mqtt
remove_volume ${stack_name}_vault

docker rm -f pio