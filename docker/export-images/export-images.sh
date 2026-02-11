#!/usr/bin/env bash
set -eo pipefail

# Edit these variables below depending on you

REPO_URL="https://nexus.domain.com"
EXPORT_DIR="./env-images"
EXPORT_FILE="env-images"
CONTAINER_BIN="docker"
HELM_VALUES_FILE="images.yaml"

if ! command -v yq  &> /dev/null
then
    echo "yq could not be found"
    exit
fi

# shellcheck disable=SC2002
IMAGES=$(cat "$HELM_VALUES_FILE" | yq  '.[].image')

rm -rf ${EXPORT_DIR} || true
mkdir ${EXPORT_DIR}

echo "Start Saving..."

# shellcheck disable=SC2066
for IMAGE in ${IMAGES}
do
  FILE="${IMAGE}"
  echo ">>>>>> $FILE <<<<<<"
  FILE=$(echo "$FILE" | sed 's/\//---/g')
  # shellcheck disable=SC2001
  FILE=$(echo "$FILE" | sed 's/:/___/g')

  $CONTAINER_BIN  pull "${REPO_URL}${IMAGE}"
  $CONTAINER_BIN  save -o ${EXPORT_DIR}/${FILE}.tar ${REPO_URL}"${IMAGE}"
  $CONTAINER_BIN  rmi "${REPO_URL}${IMAGE}"

done

tar -zcvf ${EXPORT_FILE}.tar.gz ${EXPORT_DIR}

# shellcheck disable=SC2181
if [[ "$?" == "0" ]]; then
     rm -rf $EXPORT_DIR
     echo "Finished!"
else
     echo "Error on tar command"
fi
