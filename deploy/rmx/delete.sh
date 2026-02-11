#!/usr/bin/env bash

SERVICES=("myproject-cit-service" "myproject-file-service" "myproject-config-service" "myproject-context-service" "myproject-graphics-service" "myproject-event-record-service" "myproject-notification-service")


for SRV in "${SERVICES[@]}"; do

    oc delete dc $SRV
    oc delete svc $SRV
    oc delete route $SRV
done
