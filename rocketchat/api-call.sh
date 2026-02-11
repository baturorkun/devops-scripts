#!/usr/bin/env bash

TOKEN="XXXXXXX"
USER="XXXXXXX"
CHANNEL="#pipeline"
MESSAGE="This is a test! API TEST"
DOMAIN="https://rocketchat.domain.com"

curl -H "X-Auth-Token: ${TOKEN}" \
     -H "X-User-Id: ${USER}" \
     -H "Content-type:application/json" \
     -d "{ \"channel\": \"${CHANNEL}\", \"text\": \"${MESSAGE}\" }" \
     https://${DOMAIN}/api/v1/chat.postMessage