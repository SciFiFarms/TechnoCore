#!/bin/bash
technocore_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${technocore_folder}/../.env 

docker build ./docs/ -t ${image_provider}/docs:$TAG
docker build ./home-assistant/ -t ${image_provider}/home-assistant:$TAG
docker build ./home-assistant-db/ -t ${image_provider}/home-assistant-db:$TAG
docker build ./node-red/ -t ${image_provider}/node-red:$TAG
docker build ./platformio/ -t ${image_provider}/platformio:$TAG
docker build ./vault/ -t ${image_provider}/vault:$TAG
docker build ./vernemq/ -t ${image_provider}/vernemq:$TAG
docker build ./portainer/ -t ${image_provider}/portainer:$TAG
