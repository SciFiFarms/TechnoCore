#!/bin/bash
technocore_folder=$(cd $(dirname $0) && pwd/..)
source ${technocore_folder}/.env 
docker build ./docs/ -t ${image_provider}/docs:$tag
docker build ./home-assistant/ -t ${image_provider}/home-assistant:$tag
docker build ./home-assistant-db/ -t ${image_provider}/home-assistant-db:$tag
docker build ./node-red/ -t ${image_provider}/node-red:$tag
docker build ./platformio/ -t ${image_provider}/platformio:$tag
docker build ./vault/ -t ${image_provider}/vault:$tag
docker build ./vernemq/ -t ${image_provider}/vernemq:$tag
docker build ./portainer/ -t ${image_provider}/portainer:$tag
