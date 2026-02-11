#!/usr/bin/env bash

oc apply -f deploy.sh
oc import-image myweb --confirm --all --scheduled --from nexus.mydomain.com/myweb
#oc import-image myweb --confirm --all --from nexus.mydomain.com/myweb
oc set triggers deployment/myweb --from-image myweb:latest -c myweb


# monitoring

oc get deployment myweb -o yaml | grep -A2 annotations:

oc describe is myweb

skopeo inspect  docker://nexus.mydomain.com/myproject-cit-service:latest


oc get pod <POD_NAME> -o jsonpath='{.spec.containers[0].image}{"\n"}'