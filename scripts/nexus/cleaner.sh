#!/bin/bash
set -euo pipefail


### ENVs
# Defaults

function usage()
{
    echo "Usages:"
    echo ""
    echo "./cleaner.sh"
    echo ""
}

echo "Getting parameters"
set +u
while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --gitlab-url)
            GITLAB_URL=$VALUE
            ;;
        --gitlab-token)
            GITLAB_TOKEN=$VALUE
            ;;
        --gitlab-project-id)
            GITLAB_PROJECT_ID=$VALUE
            ;;
        --nexus-user)
            NEXUS_USER=$VALUE
            ;;
         --nexus-passwd)
            NEXUS_PASSWD=$VALUE
            ;;
        --nexus-url)
            NEXUS_URL=$VALUE
            ;;
        --nexus-keep-tags)
            NEXUS_KEEP_TAGS=$VALUE
            ;;
        --nexus-keep-tags-list)
            NEXUS_KEEP_TAGS_LIST=$VALUE
            ;;
        --nexus-filter-images)
            NEXUS_FILTER_IMAGES=$VALUE
            ;;
        --nexus-docker-repository)
            NEXUS_DOCKER_REPOSITORY=$VALUE
            ;;
        --debug)
            DEBUG="yes"
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done


if ! [ -z $DEBUG ]; then
    echo "DEBUG mode is open"
    set -x
fi



if [ -z $GITLAB_URL ]; then
    echo "GITLAB_URL parameter is missing [ --gitlab-url ]"
    exit
fi

if [ -z $GITLAB_TOKEN ]; then
    echo "GITLAB_TOKEN parameter is missing [ --gitlab-token ]"
    exit
fi

if [ -z $NEXUS_USER ]; then
    echo "NEXUS_USER parameter is missing [ --nexus-user ]"
    exit
fi

if [ -z $NEXUS_PASSWD ]; then
    echo "NEXUS_PASSWD parameter is missing [ --nexus-passwd ]"
    exit
fi

if [ -z $NEXUS_URL ]; then
    echo "NEXUS_URL parameter is missing [ --nexus-url ]"
    exit
fi


if [ -z $GITLAB_PROJECT_ID ]; then
    echo "GITLAB_PROJECT_ID parameter is missing [ --gitlab-project-id ]"
    exit
fi

if [ -z $NEXUS_DOCKER_REPOSITORY ]; then
    echo "GITLAB_PROJECT_ID parameter is missing [ --nexus-docker-repository ]"
    exit
fi


if [ -z "$NEXUS_FILTER_IMAGES" ]; then
    echo "Warning: NEXUS_FILTER_IMAGES parameter is missing [ --nexus-filter-images ]"
fi

if [ -z "$NEXUS_KEEP_TAGS_LIST" ]; then
    echo "Warning: NEXUS_KEEP_TAGS_LIST parameter is missing [  --nexus-keep-tags-list ]"
fi

set -u

echo "Getting Nexus Tags..."

NEXUS_TAGS_ARRAY=("")

continuationToken=$(curl -s -u "$NEXUS_USER:$NEXUS_PASSWD" -X GET "$NEXUS_URL/service/rest/v1/search?repository=docker-hosted" | jq -r '.continuationToken')
echo "continuationToken: $continuationToken"

while true; do

  if [[ "$continuationToken" == "null" ]]; then
      ARR=( $(curl -s -u "$NEXUS_USER:$NEXUS_PASSWD" -X GET "$NEXUS_URL/service/rest/v1/search?repository=docker-hosted" |  jq -r '.items[] | .name + ":" + .version') )
  else
      echo "New Page..."
      ARR=( $(curl -s -u "$NEXUS_USER:$NEXUS_PASSWD" -X GET "$NEXUS_URL/service/rest/v1/search?repository=docker-hosted&continuationToken=$continuationToken" | jq -r '.items[] | .name + ":" + .version') )
      continuationToken=$(curl -s -u "$NEXUS_USER:$NEXUS_PASSWD" -X GET "$NEXUS_URL/service/rest/v1/search?repository=docker-hosted&continuationToken=$continuationToken" | jq -r '.continuationToken')
      echo "continuationToken: $continuationToken"
  fi

  NEXUS_TAGS_ARRAY=($(echo ${NEXUS_TAGS_ARRAY[*]}) $(echo ${ARR[*]}))


  if [[ "$continuationToken" == "null" ]]; then
      echo "finished nexus pagination"
      break
  fi

done


echo "------------------------------------------------------------------------------------------------------------------"
# shellcheck disable=SC2145
echo "NEXUS_TAGS_ARRAY : ${NEXUS_TAGS_ARRAY[@]}"
echo "------------------------------------------------------------------------------------------------------------------"


GIT_BRANCHES_LIST=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_URL/api/v4/projects/${GITLAB_PROJECT_ID}/repository/branches" | jq -r '.[].name' |  cut -f1 -d"-")
GIT_TAGS_LIST=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_URL/api/v4/projects/${GITLAB_PROJECT_ID}/repository/tags" | jq -r '.[].name')


# shellcheck disable=SC2066
for OBJ in "${NEXUS_TAGS_ARRAY[@]}"; do
    SRV=$(echo "$OBJ" | cut -d ":" -f1)
    TAG=$(echo "$OBJ" | cut -d ":" -f2)

    echo ">>> IMAGE: $SRV : $TAG"

    if [[ "$TAG" == *"."* ]]; then
       echo "This is TAG"
       LIST=$GIT_TAGS_LIST
    else
       echo "This is Branch"
       LIST=$GIT_BRANCHES_LIST
    fi

    if ! [ -z "$NEXUS_KEEP_TAGS_LIST" ]; then
        # shellcheck disable=SC2143
        if [[ $(echo "$NEXUS_KEEP_TAGS_LIST" | grep -E "${TAG}") ]]; then
              echo "+++++ $TAG is alive +++++"
              continue
          fi
    fi

    echo "Checking NEXUS KEEP TAGS..."
    # shellcheck disable=SC2143
    if [[ $(echo "$TAG" | grep -E "$NEXUS_KEEP_TAGS") ]]; then
        echo "* Keep TAG : $TAG"
        continue
    fi

    if ! [ -z "$NEXUS_FILTER_IMAGES" ]; then
        echo "Checking NEXUS FILTER IMAGES..."
        if [[ $(echo "$SRV" | grep -E "$NEXUS_FILTER_IMAGES") == "" ]]; then
            echo "* Keep IMAGE : $SRV"
            continue
        fi
    fi

    echo "Checking LIVE TAGS..."
    if [[ $(echo "$LIST" | grep -E "^${TAG}$") ]]; then
        echo "++++++++++++++++++++ $TAG is alive"
        continue
    fi

    echo "!!!!!! Deleting  $SRV : $TAG !!!!!"

    echo "- $TAG is dead. Deleting..."
    IMAGE_SHA=$(curl --silent -I -X GET -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -u ${NEXUS_USER}:${NEXUS_PASSWD} "${NEXUS_URL}/repository/docker-hosted/v2/${SRV}/manifests/$TAG" | grep Docker-Content-Digest | cut -d ":" -f3 | tr -d '\r')
    echo "DELETE ${TAG} ${IMAGE_SHA}";
    DEL_URL="${NEXUS_URL}/repository/docker-hosted/v2/${SRV}/manifests/sha256:${IMAGE_SHA}"
    #echo $DEL_URL
    RET="$(curl --silent -k -X DELETE -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -u ${NEXUS_USER}:${NEXUS_PASSWD} $DEL_URL)"
    echo $RET

done
