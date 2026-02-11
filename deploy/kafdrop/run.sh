#!/usr/bin/env bash

oc apply -f pod.yaml
oc apply -f service.yaml

oc expose svc/kafdrop