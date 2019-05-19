technocore_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ -f "${technocore_folder}/../.env " ]; then
    source ${technocore_folder}/../.env 
fi

# One liner to exec in a docker service by name instead of hash. 
alias run_mqtt='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_mqtt | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_mqtt | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_node_red='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_node_red | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_node_red | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_home_assistant_db='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_home_assistant_db | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_home_assistant_db | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_vault='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_vault | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_vault | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_home_assistant='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_home_assistant | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_home_assistant | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
# TODO: Create a run_container function that takes in the service name as an argument. 
# I had to add this because I needed to run portainer as a sub-command in install.sh.
function run_portainer()
{
    docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_portainer | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_portainer | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash $@
}
alias run_docs='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_docs | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_docs | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_nginx='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_nginx | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_nginx | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_esphomeyaml_wrapper='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_esphomeyaml | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_esphomeyaml | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_grafana='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_grafana | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_grafana | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_health='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_status | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_status | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_jupyter='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_jupyter | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_jupyter | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_logs='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_logs | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_logs | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_timeseries_db='docker exec -it $(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_timeseries_db | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc ${stack_name:-technocore}_timeseries_db | grep ${stack_name:-technocore} | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_esphomeyaml='docker exec -it ${stack_name:-technocore}_esphomeyaml_app /bin/bash'
alias remove_all_containers='docker ps --no-trunc -aq | xargs docker rm -f'
alias remove_all_volumes='docker volume ls -q | xargs docker volume rm -f'

# TODO: It may be useful to figure out how to run this in the closest parent 
# directory that contains a docker-compose.yml file. 
# Found on: https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
# TODO: This is duplicated in portainer/shell-migrations/20190324221228-grafana_and_jupyter-migrate.sh
if [ -f "${technocore_folder}/../.env " ]; then
    alias deploy='env $(egrep -v "^#" .env | xargs) docker stack deploy --compose-file docker-compose.yml'
else
    alias deploy='docker stack deploy --compose-file docker-compose.yml'
fi
# TODO: Add subrepo here?
