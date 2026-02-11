#!/usr/bin/env bash

SERVICES=("myproject-cit-service:58451" "myproject-file-service:58456" "myproject-config-service:58453" "myproject-context-service:58450" "myproject-graphics-service:58455" "myproject-event-record-service:58452" "myproject-notification-service:58454")


if [ -z $1 ]; then
    echo "Parameter 1: TAG name is missing"
    exit
fi

TAG=$1

for SRV in "${SERVICES[@]}"; do
    arr=($(echo "$SRV" | tr ':' '\n'))
    NAME=${arr[0]}
    PORT=${arr[1]}

    oc process -f rmx-template.yaml -p APP=$NAME -p TAG=$TAG -p PORT=$PORT | oc create -f -
    oc import-image $NAME --confirm --all --scheduled --from nexus.mydomain.com/$NAME
    oc rollout latest dc/$NAME
    oc expose svc/$NAME
done
