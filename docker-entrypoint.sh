#!/usr/bin/env sh
set -e

for container_id in $(docker ps -q)
do
    NAME=`docker inspect --format '{{.Name}}' ${container_id} | sed "s/\///g"`
    IMAGE=`docker inspect --format "{{.Config.Image}}" ${container_id}`
    echo "${NAME}: Pulling latest version of image ${IMAGE}"
    docker pull $IMAGE
    LATEST=`docker inspect --format "{{.Id}}" ${IMAGE}`
    RUNNING=`docker inspect --format "{{.Image}}" ${container_id}`
    echo "${NAME}: LATEST=${LATEST} RUNNING=${RUNNING}"
    if [ "$RUNNING" != "$LATEST" ];then
        echo "${NAME}: Shutting down container and allowing systemd to restart with new version..."
    else
        echo "${NAME}: No update required"
    fi
    echo ""
done
