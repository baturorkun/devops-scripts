#!/usr/bin/env bash

oc apply -f zookeeper-deploy.yaml
oc apply -f zookeeper-service.yaml

oc apply -f kafka-service.yaml
oc apply -f kafka-deploy.yaml

oc apply -f kafka-cat.yaml
