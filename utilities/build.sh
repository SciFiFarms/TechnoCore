#!/bin/bash
technocore_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${technocore_folder}/../.env 

docker build ./docs/ -t ${image_provider}/technocore-docs:$TAG
docker build ./home-assistant/ -t ${image_provider}/technocore-home-assistant:$TAG
docker build ./home-assistant-db/ -t ${image_provider}/technocore-home-assistant-db:$TAG
docker build ./node-red/ -t ${image_provider}/technocore-node-red:$TAG
docker build ./platformio/ -t ${image_provider}/technocore-platformio:$TAG
docker build ./platformio-wrapper/ -t ${image_provider}/technocore-platformio-wrapper:$TAG
docker build ./vault/ -t ${image_provider}/technocore-vault:$TAG
docker build ./vernemq/ -t ${image_provider}/technocore-vernemq:$TAG
docker build ./portainer/ -t ${image_provider}/technocore-portainer:$TAG
docker build ./nginx/ -t ${image_provider}/technocore-nginx:$TAG
