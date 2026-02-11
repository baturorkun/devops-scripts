#!/usr/bin/env bash

# nexus
docker build -t myweb2 .
docker tag myweb2:latest 192.168.2.215:9082/myweb2
docker login --username admin --password "TrustNo1*"  192.168.2.215:9082
docker push 192.168.2.215:9082/myweb2


# ocp
oc apply -f deploy-config.sh
oc import-image myweb2 --confirm --all --scheduled --from nexus.mydomain.com/myweb2
#oc import-image myweb --confirm --all --from nexus.mydomain.com/myweb
#oc set triggers deployment/myweb2 --from-image myweb:latest -c myweb

oc expose svc/myweb2

# monitoring

oc get deployment myweb -o yaml | grep -A2 annotations:

oc describe is myweb2

skopeo inspect  docker://nexus.mydomain.com/myproject-cit-service:latest


oc get pod <POD_NAME> -o jsonpath='{.spec.containers[0].image}{"\n"}'


oc rollout latest dc/myweb2
