#!/bin/bash
technocore_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ -f "${technocore_folder}/../.env" ]; then
    source ${technocore_folder}/../.env 
fi

# TODO: Make these reference docker-compose.yaml like clean.sh does.
docker build ./docs/ -t ${image_provider:-scififarms}/technocore-docs:${TAG:-latest}
docker build -f ./esphome/docker/Dockerfile ./esphome/ -t ${image_provider:-scififarms}/technocore-esphome:${TAG:-latest}
docker build ./esphome-wrapper/ -t ${image_provider:-scififarms}/technocore-esphome-wrapper:${TAG:-latest}
docker build ./grafana/ -t ${image_provider:-scififarms}/technocore-grafana:${TAG:-latest}
docker build ./home-assistant/ -t ${image_provider:-scififarms}/technocore-home-assistant:${TAG:-latest}
docker build ./home-assistant-db/ -t ${image_provider:-scififarms}/technocore-home-assistant-db:${TAG:-latest}
docker build ./nextcloud-exporter/ -t ${image_provider:-scififarms}/technocore-nextcloud-exporter:${TAG:-latest}
docker build ./nginx/ -t ${image_provider:-scififarms}/technocore-nginx:${TAG:-latest}
docker build ./node-red/ -t ${image_provider:-scififarms}/technocore-node-red:${TAG:-latest}
docker build ./portainer/ -t ${image_provider:-scififarms}/technocore-portainer:${TAG:-latest}
docker build ./vault/ -t ${image_provider:-scififarms}/technocore-vault:${TAG:-latest}
docker build ./vernemq/ -t ${image_provider:-scififarms}/technocore-vernemq:${TAG:-latest}
docker build ./jupyter/ -t ${image_provider:-scififarms}/technocore-jupyter:${TAG:-latest}
docker build ./influxdb/ -t ${image_provider:-scififarms}/technocore-influxdb:${TAG:-latest}
docker build ./prometheus/ -t ${image_provider:-scififarms}/technocore-prometheus:${TAG:-latest}
docker build ./loki/ -t ${image_provider:-scififarms}/technocore-loki:${TAG:-latest}
docker build ./fluentd/ -t ${image_provider:-scififarms}/technocore-fluentd:${TAG:-latest}
