#!/usr/bin/env bash
set -x
source utils.sh

usage() {
  echo "Usage Example:"
  echo "install.sh \ "
  echo " --namespace-prefix \ "
  echo " --basedomain=domain.com \ "
  echo " --file | -f=test-environment-values.yaml \ "
}

echo "Checking requirements..."

if ! command -v yq &> /dev/null; then
    echo "Error: yq binary is missing. Github URL:  https://github.com/mikefarah/yq"
    exit 1
fi

if ! command -v kubens &> /dev/null; then
    echo "Error: kubens binary is missing. Github URL:  https://github.com/ahmetb/kubectx"
    exit 1
fi

if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl binary is missing. Download URL:  https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

echo "Checking parameters..."

while [ "$1" != "" ]; do
    PARAM=$(echo $1 | awk -F= '{print $1}')
    VALUE=$(echo $1 | awk -F= '{print $2}')
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -f | --file)
            export VALUE_FILE=$VALUE
            ;;
        -s | --services)
            export SERVICES=$VALUE
            ;;
        --debug)
            DEBUG=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

export BASEPATH=$(pwd)

#if [[ "${NAMESPACE}" == "" ]]; then
#    echo "*** ERROR *** Namespace is empty!"
#    usage
#    exit
#else
#    echo "Namespace = $NAMESPACE"
#fi

#if [[ "${BASEDOMAIN}" == "" ]]; then
#    echo "*** ERROR *** BaseDomain is empty!"
#    usage
#    exit
#else
#    echo "BaseDomain = $BASEDOMAIN"
#fi


#kubens "${NAMESPACE}"
#
#if [[ "$?" == "1" ]]; then
#    kubectl create namespace "${NAMESPACE}"
#    kubens "${NAMESPACE}"
#fi
#
#ACTIVE_NS=$(kubens -c)
#
#if [[ "$ACTIVE_NS" != "${NAMESPACE}" ]]; then
#    echo "Active Namespace is not RIGHT!"
#    exit
#fi

echo "**$VALUE_FILE"

if [[ "$SERVICES" != "" ]]; then
    IFS=', ' read -r -a SERVICES <<< "$SERVICES"
else
    SERVICES=$(yq -o=json "$VALUE_FILE"  | jq -r '.|keys[]')
    readarray -t SERVICES <<<"$SERVICES"
fi

# shellcheck disable=SC2145
echo "Services = ${SERVICES[@]}"

for NAME in "${SERVICES[@]}"; do

    cd "${BASEPATH}/${NAME}"

    exit

    ENABLED=$(cat ${BASEPATH}/${VALUE_FILE}  |  yq .${NAME}.enabled)

    if [[ "${ENABLED}" == "false" ]]; then
        echo "##################################################"
        echo "---------- Uninstalling ${NAME}...( Enabled is False ) -----------"
        FNC_createValuesFile
        bash uninstall.sh
        continue
    elif [[ "${ENABLED}" != "true" ]]; then
        echo "##################################################"
        echo "?????????? Do nothing - Ignoring ${NAME}...( Enabled is Unknown) ??????????"
        continue
    fi

    echo "##################################################"
    echo "++++++++++ Installing ${NAME}...( Enabled = True ) ++++++++++++"

    FNC_createValuesFile

    bash install.sh
done
