#!/usr/bin/env bash

create configmap keycloak-config --from-file=config/
oc apply -f keycloak.yaml
oc apply -f route.yaml

#oc expose svc/keycloak

echo "Wait 10 sec"
sleep 10

while true; do
   POD=$(kubectl get pods -l app=keycloak --field-selector=status.phase=Running -o jsonpath="{.items[0].metadata.name}")
   if [[ "$POD" != "" ]]; then
     echo "Copying to ${POD}..."
     kubectl cp ./keycloak-themes/map-sample-app $POD:/opt/jboss/keycloak/themes/
     echo "Done"
     break
   fi
   echo "Wait 5 sec"
   sleep 5
done


