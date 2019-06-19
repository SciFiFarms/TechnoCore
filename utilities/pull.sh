#!/bin/bash
technocore_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [ -f "${technocore_folder}/../.env" ]; then
    source ${technocore_folder}/../.env 
fi

docker pull ${image_provider:-scififarms}/technocore-docs:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-home-assistant:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-home-assistant-db:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-node-red:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-esphome:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-esphome-wrapper:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-vault:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-vernemq:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-portainer:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-nginx:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-jupyter:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-grafana:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-influxdb:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-loki:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-prometheus:${TAG:-latest}
docker pull ${image_provider:-scififarms}/technocore-nextcloud-exporter:${TAG:-latest}
