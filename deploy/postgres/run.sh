#!/usr/bin/env bash

oc apply -f postgres-config.yaml,postgres-stateful.yaml,postgres-service.yaml

