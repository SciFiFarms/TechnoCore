#!/bin/bash
technocore_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${technocore_folder}/../.env 

# TODO: Make these reference docker-compose.yaml like clean.sh does.
docker build ./docs/ -t ${image_provider}/technocore-docs:$TAG
docker build -f ./esphomeyaml/docker/Dockerfile ./esphomeyaml/ -t ${image_provider}/technocore-esphomeyaml:$TAG
docker build ./esphomeyaml-wrapper/ -t ${image_provider}/technocore-esphomeyaml-wrapper:$TAG
docker build ./home-assistant/ -t ${image_provider}/technocore-home-assistant:$TAG
docker build ./home-assistant-db/ -t ${image_provider}/technocore-home-assistant-db:$TAG
docker build ./nginx/ -t ${image_provider}/technocore-nginx:$TAG
docker build ./node-red/ -t ${image_provider}/technocore-node-red:$TAG
docker build ./portainer/ -t ${image_provider}/technocore-portainer:$TAG
docker build ./vault/ -t ${image_provider}/technocore-vault:$TAG
docker build ./vernemq/ -t ${image_provider}/technocore-vernemq:$TAG
