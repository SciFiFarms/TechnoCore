# TODO: I doubt this works.
technocore_folder=$(cd $(dirname $0) && pwd/..)
source ${technocore_folder}/.env 

# One liner to exec in a docker service by name instead of hash. 
alias run_mqtt='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_mqtt | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_mqtt | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_nr='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_nr | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_nr | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_ha_db='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_ha_db | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_ha_db | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_vault='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_vault | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_vault | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_ha='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_ha | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_ha | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_platformio='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_platformio | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_platformio | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_portainer='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_portainer | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_portainer | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_docs='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_docs | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_docs | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/sh'

alias deploy='env $(cat ../AllThing/.env | grep ^[A-Z] | xargs) docker stack deploy --compose-file ../AllThing/docker-compose.yml'