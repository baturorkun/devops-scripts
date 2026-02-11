#!/usr/bin/env bash


REPO_URL=nexus.mydomain.com/

CONTAINER_BIN=docker

TAG=1.6.0

IMAGES=(
    "prj-backend"
    "prj-db-adapter"
    "prj-dbsa-adapter"
    "prj-gbsa-adapter"
    "prj-lens-adapter"
    "prj-spc-adapter"
    "prj-algorithm-service"
    "prj-analysis-service"
    "prj-analysis-dispatcher-service"
    "prj-ehkkks-adapter"
    "prj-hfed-adapter"
     "prj-db-adapter"
     "prj-vuhfed3a3-adapter"
     "prj-ui"
)


for IMAGE in "${IMAGES[@]}"
do

  $CONTAINER_BIN pull "${REPO_URL}${IMAGE}:${TAG}"


done

