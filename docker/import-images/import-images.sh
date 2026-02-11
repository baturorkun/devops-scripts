#!/usr/bin/env bash
set -ex

# Edit these variables below depending on you

REPO_URL="nexus.mydomain.com:32000/"
EXPORT_DIR="./env-images"
EXPORT_FILE="env-images"
CONTAINER_BIN="docker"
HELM_VALUES_FILE="data.yaml"

# shellcheck disable=SC2002
IMAGES=$(cat "$HELM_VALUES_FILE" | yq  '.[].image')

rm -rf ${EXPORT_DIR} || true
mkdir ${EXPORT_DIR}

echo "Start untar..."

tar -zxvf ${EXPORT_FILE}.tar.gz

# shellcheck disable=SC2066
for IMAGE in ${IMAGES}
do
  FILE="${IMAGE}"
  echo ">>>>>> $FILE <<<<<<"
  FILE=$(echo "$FILE" | sed 's/\//---/g')
  # shellcheck disable=SC2001
  FILE=$(echo "$FILE" | sed 's/:/___/g')

  $CONTAINER_BIN load -i ${EXPORT_DIR}/${FILE}.tar

  $CONTAINER_BIN tag nexus.mydomain.com.tr/"${IMAGE}" ${REPO_URL}"${IMAGE}"

  $CONTAINER_BIN push ${REPO_URL}"${IMAGE}"

done

rm -rf ${EXPORT_DIR}
