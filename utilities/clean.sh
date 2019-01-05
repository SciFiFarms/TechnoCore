#!/bin/bash

technocore_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )/../"
source ${technocore_folder}.env 

# $@ the arguments to pass into yq. See http://mikefarah.github.io/yq/
yq() {
    docker run -v $technocore_folder/:/workdir mikefarah/yq:2.2.0 yq $@
}

remove_volume() {
    echo "Removing volume $1."
    local response # Declare response as a local var.
    until response=$(docker volume rm $1 2>&1)
    do 
        if grep -q 'No such volume' <<< $response; then
            echo "Volume $1 doesn't exist, so it won't be removed."
            break
        fi
        if grep -q 'volume is in use' <<< $response; then
            local container=$(echo "$response" | cut -d"[" -f2 | cut -d"]" -f1 | tr "," " " )
            echo "Volume is in use by container $container. Will stop."
            docker rm -f $container
        fi
        sleep 2
    done
}

# Remove all the secrets
for secret in $(yq read docker-compose.yml 'secrets.*.name')
do
    if [ "$secret" = "-" ]; then
        continue
    fi
    #echo $(eval echo $secret)
    secret=$(eval echo $secret)
    echo "Removing secret $(docker secret rm $secret)"
done

# Remove all the volumes
for volume in $(yq read docker-compose.yml 'volumes' | cut -f1 -d:)
do
    if [ ! $volume -o "$volume" = "-" ]; then
        continue
    fi
    #echo $(eval echo $volume)
    volume=$(eval echo $volume | cut -f1 -d:)
    remove_volume ${stack_name}_$volume
done

# Remove the platformio workaround container. 
docker rm -f pio 2> /dev/null 