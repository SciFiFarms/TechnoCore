#!/usr/bin/env bash

# Adds the repo if it is missing. 
# $1: The url of the repo to add
# $2 (optional): The branch to checkout.
add_repo_if_missing()
{
    local folder=${1,,}
    local folder=${folder/technocore-/}
    local branch=${2:-master}
    if [ ! -d "$folder" ]; then
        git clone https://github.com/SciFiFarms/$1.git $folder -b $branch
        echo "Added $folder repo"
    else
        echo "$folder already exists. Will not overwrite repo."
    fi
}

add_repo_if_missing TechnoCore-Grafana 
add_repo_if_missing TechnoCore-Prometheus 
add_repo_if_missing TechnoCore-Alertmanager 
add_repo_if_missing TechnoCore-Fail2ban 
add_repo_if_missing TechnoCore-Grav 
add_repo_if_missing TechnoCore-Nextcloud
add_repo_if_missing TechnoCore-Nextcloud-Onlyoffice
add_repo_if_missing TechnoCore-Ouroboros
add_repo_if_missing TechnoCore-traefik-subdomain

add_repo_if_missing TechnoCore-ESPHome master
add_repo_if_missing TechnoCore-ESPHome-Wrapper 
add_repo_if_missing TechnoCore-Home-Assistant 
add_repo_if_missing TechnoCore-Home-Assistant-DB 
add_repo_if_missing TechnoCore-Vault 
add_repo_if_missing TechnoCore-VerneMQ 
add_repo_if_missing TechnoCore-InfluxDB 
add_repo_if_missing TechnoCore-Syncthing
add_repo_if_missing TechnoCore-Jupyter 
add_repo_if_missing TechnoCore-Node-RED 
add_repo_if_missing TechnoCore-SMTP-Relay
add_repo_if_missing TechnoCore-Mattermost

#add_repo_if_missing TechnoCore-Loki 

#add_repo_if_missing TechnoCore-Docs 
#add_repo_if_missing dogfish 
#add_repo_if_missing TechnoCore-fluentd 
#add_repo_if_missing TechnoCore-nextcloud-exporter 
#add_repo_if_missing TechnoCore-NGINX 
#add_repo_if_missing TechnoCore-Portainer 
#add_repo_if_missing TechnoCore-ESPHome-Core 
