#!/bin/bash
technocore_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${technocore_folder}/../.env 

docker pull ${image_provider}/technocore-docs:$TAG
docker pull ${image_provider}/technocore-home-assistant:$TAG
docker pull ${image_provider}/technocore-home-assistant-db:$TAG
docker pull ${image_provider}/technocore-node-red:$TAG
docker pull ${image_provider}/technocore-platformio:$TAG
docker pull ${image_provider}/technocore-platformio-wrapper:$TAG
docker pull ${image_provider}/technocore-vault:$TAG
docker pull ${image_provider}/technocore-vernemq:$TAG
docker pull ${image_provider}/technocore-portainer:$TAG
docker pull ${image_provider}/technocore-nginx:$TAG
docker pull ${image_provider}/technocore-nginx-docker-gen:$TAG
