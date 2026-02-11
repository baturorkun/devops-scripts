#!/usr/bin/env bash

oc apply -f stateful.yaml

sleep 30

kubectl cp www/index.html web-0:/usr/share/nginx/html/