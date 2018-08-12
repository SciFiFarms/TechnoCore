# One liner to exec in a docker service by name instead of hash. 
alias run_mqtt='docker exec -it $(docker service ps -f desired-state=running --no-trunc althing_dev_mqtt | grep althing_dev | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc althing_dev_mqtt | grep althing_dev | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_nr='docker exec -it $(docker service ps -f desired-state=running --no-trunc althing_dev_nr | grep althing_dev | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc althing_dev_nr | grep althing_dev | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_ha_db='docker exec -it $(docker service ps -f desired-state=running --no-trunc althing_dev_ha_db | grep althing_dev | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc althing_dev_ha_db | grep althing_dev | tr -s " " | cut -d " " -f 1) /bin/bash'
alias run_vault='docker exec -it $(docker service ps -f desired-state=running --no-trunc althing_dev_vault | grep althing_dev | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc althing_dev_vault | grep althing_dev | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_ha='docker exec -it $(docker service ps -f desired-state=running --no-trunc althing_dev_ha | grep althing_dev | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc althing_dev_ha | grep althing_dev | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_platformio='docker exec -it $(docker service ps -f desired-state=running --no-trunc althing_dev_platformio | grep althing_dev | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc althing_dev_platformio | grep althing_dev | tr -s " " | cut -d " " -f 1) /bin/sh'
alias run_docs='docker exec -it $(docker service ps -f desired-state=running --no-trunc althing_dev_docs | grep althing_dev | tr -s " " | cut -d " " -f 2).$(docker service ps -f desired-state=running --no-trunc althing_dev_docs | grep althing_dev | tr -s " " | cut -d " " -f 1) /bin/sh'

alias deploy='env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy --compose-file docker-compose.yml'