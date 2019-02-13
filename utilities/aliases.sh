technocore_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${technocore_folder}/../.env 

# One liner to exec in a docker service by name instead of hash. 
alias run_mqtt='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_mqtt | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_mqtt | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_node_red='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_node_red | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_node_red | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_home_assistant_db='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_home_assistant_db | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_home_assistant_db | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_vault='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_vault | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_vault | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_home_assistant='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_home_assistant | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_home_assistant | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/bash'
# TODO: Create a run_container function that takes in the service name as an argument. 
# I had to add this because I needed to run portainer as a sub-command in install.sh.
function run_portainer()
{
    docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_portainer | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_portainer | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/sh $@
}
alias run_docs='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_docs | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_docs | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_nginx='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_nginx | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_nginx | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_esphomeyaml_wrapper='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name}_esphomeyaml | grep ${stack_name} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name}_esphomeyaml | grep ${stack_name} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_esphomeyaml='docker exec -it ${stack_name}_esphomeyaml_app /bin/bash'
alias remove_all_containers='docker ps --no-trunc -aq | xargs docker rm -f'
alias remove_all_volumes='docker volume ls -q | xargs docker volume rm -f'

# TODO: It may be useful to figure out how to run this in the closest parent 
# directory that contains a docker-compose.yml file. 
# Found on: https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
alias deploy='env $(egrep -v "^#" .env | xargs) docker stack deploy --compose-file docker-compose.yml'
# TODO: Add subrepo here?
