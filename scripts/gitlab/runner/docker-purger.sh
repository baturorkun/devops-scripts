#!/bin/sh

# copy the file to /etc/cron.daily/

# delete dangling images
docker rmi $(docker images -f "dangling=true" -q)

# delete exited containers
docker rm $(docker ps -a -f status=exited -q)

