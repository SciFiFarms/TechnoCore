#!/bin/bash
tag=local
docker build ../docs/ -t allthing/docs:$tag
docker build ../home-assistant/ -t allthing/home-assistant:$tag
docker build ../home-assistant-db/ -t allthing/home-assistant-db:$tag
docker build ../node-red/ -t allthing/node-red:$tag
docker build ../platformio/ -t allthing/platformio:$tag
docker build ../rabbitmq/ -t allthing/rabbitmq:$tag
docker build ../vault/ -t allthing/vault:$tag
docker build ../vernemq/ -t allthing/vernemq:$tag
docker build ../portainer/ -t allthing/portainer:$tag