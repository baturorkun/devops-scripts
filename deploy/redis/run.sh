#!/usr/bin/env bash

oc process -f redis-cluster.yml -p DOCKER_PATH_AND_IMAGE=redis:6.0.8 -p NAME=redis | oc create -f -