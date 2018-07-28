#!/bin/bash

remove_volume() {
    bad_text="No such volume"
    response=$(docker volume rm $1)
    while [ $? != 0 ]; do
        grep -q 'No such volume' <<< $response 
        if [ $? ]; then
            echo "Volume $1 doesn't exist, so it won't be removed."
            break
        else
            echo "Couldn't remove volume $1. Sleeping."
            sleep 1
            response=$(docker volume rm $1)
        fi
    done
    echo "Removed volume $1."
}

remove_volume althing_dev_home-assistant-db 
remove_volume althing_dev_home-assistant-db-migrations
remove_volume althing_dev_node-red