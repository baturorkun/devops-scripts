#!/usr/bin/env bash
set -exo pipefail

DOCKER_PUSH_URL="192.168.2.215:9082/"
DOCKER_PUSH_USER="admin"
DOCKER_PUSH_PASSWD="TrustNo1*"
DOCKER_TAG="1.7.0"
NEW_TAG="prod"

echo "************* DOCKER TAG LINK  ****************"
echo "LINK TAG: ${DOCKER_TAG} --> ${NEW_TAG}"
echo "***********************************************"
#DOCKER_TAG=$(FNC_set_docker_tag "${CI_COMMIT_REF_NAME}")

SERVICES=(
         # "myproject-cit-service"
         # "myproject-file-service"
         # "myproject-config-service"
         # "myproject-user-settings-service"
         # "myproject-context-service"
         # "myproject-graphics-service"
         # "myproject-event-record-service"
         # "myproject-notification-service"
         # "myproject-window-sample-app-backend"
         # "myproject-window-sample-app-frontend"
         # "myproject-navigation-redis-to-multicast-service"
         # "myproject-sample-cit-adapter-service"
         # "myproject-navigation-redis-to-multicast-service"
          "myproject-maintenance-service"
          )

docker login ${DOCKER_PUSH_URL} -u ${DOCKER_PUSH_USER} -p ${DOCKER_PUSH_PASSWD}

for SRV in "${SERVICES[@]}"; do
    docker pull ${DOCKER_PUSH_URL}${SRV}:${DOCKER_TAG}
    docker tag ${DOCKER_PUSH_URL}${SRV}:${DOCKER_TAG} ${DOCKER_PUSH_URL}${SRV}:${NEW_TAG}
    docker push ${DOCKER_PUSH_URL}${SRV}:${NEW_TAG}
done
