#!/bin/bash
set -xeo pipefail

### ENVs
# Defaults

function usage()
{
    echo "Usages:"
    echo ""
    echo "./sonar.sh"
    echo ""
}

echo "Getting parameters"

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --sonar-project-key)
            SONAR_PROJECT_KEY=$VALUE
            ;;
        --sonar-java-binaries)
            SONAR_JAVA_BINARIES=$VALUE
            ;;
        --sonar-java-source)
            SONAR_JAVA_SOURCE=$VALUE
            ;;
        --git-url)
            GIT_URL=$VALUE
            ;;
         --git-user)
            GIT_USER=$VALUE
            ;;
        --git-token)
            GIT_TOKEN=$VALUE
            ;;
        --git-branch)
            GIT_BRANCH=$VALUE
            ;;
        --sonar-login)
            SONAR_LOGIN=$VALUE
            ;;
        --sonar-host)
            SONAR_HOST=$VALUE
            ;;
        --container-type)
            CONTAINER_TYPE=$VALUE
            ;;
        --run-cmd-before)
            RUN_COMMAND_BEFORE=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done


if [ -z $SONAR_PROJECT_KEY ]; then
  echo "PROJECT_KEY parameter is missing [ --sonar-project-key ]"
  exit
fi

if [ -z $SONAR_JAVA_SOURCE ]; then
    echo "Warning: SONAR_JAVA_SOURCE parameter is missing [ --sonar-java-source ]"
    echo "Default: 1.8"
    SONAR_JAVA_SOURCE="1.8"
fi

if [ -z $GIT_URL ]; then
    echo "GIT_URL parameter is missing [ --git-url ]"
    exit
fi

if [ -z $GIT_USER ]; then
    echo "GIT_USER parameter is missing [ --git-user ]"
    exit
fi

if [ -z $GIT_TOKEN ]; then
    echo "GIT_TOKEN parameter is missing [ --git-token ]"
    exit
fi

if [ -z $GIT_BRANCH ]; then
    echo "GIT_BRANCH parameter is missing [ --git-branch ]"
    exit
fi

if [ -z $SONAR_LOGIN ]; then
    echo "SONAR_LOGIN parameter is missing [ --sonar-login ]"
    exit
fi

if [ -z $SONAR_HOST ]; then
    echo "SONAR_HOST parameter is missing [ --sonar-host ]"
    exit
fi

if [ -z $CONTAINER_TYPE ]; then
    echo "Warning: CONTAINER_TYPE parameter is missing [ --container-type ]"
    echo "Default: Docker"
    CONTAINER_TYPE="docker"
fi

if [ -z $SONAR_JAVA_BINARIES ]; then
    echo "Warning : SONAR_JAVA_BINARIES parameter is missing [ --sonar-java-binaries ]"
fi

echo "Setting parameters"
GIT_URL="http://${GIT_USER}:${GIT_TOKEN}@${GIT_URL}"

rm -rf /tmp/$SONAR_PROJECT_KEY
rm -rf /tmp/sonar-cache/$SONAR_PROJECT_KEY

mkdir -p /tmp/sonar-cache/$SONAR_PROJECT_KEY
chmod -R 777 /tmp/sonar-cache

git clone  --single-branch -b $GIT_BRANCH $GIT_URL /tmp/$SONAR_PROJECT_KEY

if [[ $SONAR_JAVA_BINARIES != "" ]]; then

cat <<EOF >/tmp/$SONAR_PROJECT_KEY/sonar-project.properties
  sonar.projectKey=$SONAR_PROJECT_KEY
  sonar.java.binaries=$SONAR_JAVA_BINARIES
  sonar.java.source=$SONAR_JAVA_SOURCE
EOF
fi

if [[ "${RUN_COMMAND_BEFORE}" != "" ]]; then
    cd /tmp/$SONAR_PROJECT_KEY
    eval "${RUN_COMMAND_BEFORE}"
fi

# shellcheck disable=SC1101
$CONTAINER_TYPE run --rm --dns=192.168.2.2 \
    -v "/tmp/sonar-cache/$SONAR_PROJECT_KEY:/opt/sonar-scanner/.sonar/cache" \
    -e SONAR_PROJECT_KEY="$SONAR_PROJECT_KEY" \
    -e SONAR_HOST_URL="$SONAR_HOST" \
    -e SONAR_LOGIN="$SONAR_LOGIN" \
    -v "/tmp/$SONAR_PROJECT_KEY:/usr/src" \
  sonarsource/sonar-scanner-cli

# shellcheck disable=SC2028
echo "PROJECT [ $SONAR_PROJECT_KEY ] was completed!\n"
