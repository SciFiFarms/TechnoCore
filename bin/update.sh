#!/usr/bin/env bash

# TODO: pull needs to be added to portainer.
/var/run/technocore/utilities/pull.sh
docker service update --force ${stack_name}_portainer

# Anything that needs to happen after portainer reboots should go in a migration. 
# Otherwise credentials are referenced in docker-compose.yaml that haven't been 
# created yet. A deploy then fails because it can't find the secrets and the server is down. 

