#!/usr/bin/env bash

### ENVs

usage() {
  echo "Usage Example:"
  echo "reset-cluster.sh --net-device=eth0 \ "
  echo "                 --net-ip=192.168.2.16 \ "
  echo "                 --net-geteway=192.168.2.1 "
}

echo "Checking parameters..."

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --net-device)
            NET_DEVICE=$VALUE
            ;;
        --net-api)
            NET_IP=$VALUE
            ;;
        --net-geteway)
            NET_GATEWAY=$VALUE
            ;;
        --net-dns)
            NET_DNS=$VALUE
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


if [[ "$NET_IP" == "" ]]; then
    echo "Error: --net-ip parameter must be IP address"
    exit
fi

if [[ "$NET_DEVICE" == "" ]]; then
    echo "Error: --net-device parameter must be IP address"
    exit
fi

if [[ "$NET_GATEWAY" == "" ]]; then
    echo "Error: --net-gateway parameter must be IP address"
    exit
fi

if [[ "$NET_DNS" == "" ]]; then
    echo "Error: --net-dns parameter must be IP address"
    exit
fi

EXISTS=$(grep "$NET_IP"  /etc/rancher/rke2/config.yaml)

# shellcheck disable=SC1072
if [[ "$EXISTS" != "" ]]; then
    echo "In your RKE setting has already $NET_IP IP."
    echo "If you want to scale DOWN and UP your services, write YES"
    echo "or to exit, continue without writing anything."
    read CONTINUE

    if [[ "$(echo $CONTINUE | tr '[:upper:]' '[:lower:]')" != "yes" ]]; then
        echo "No continue..."
        exit
    fi
fi

echo "Scale DOWN all deployments..."

# Get a list of all deployments in the current namespace
deployments=$(kubectl get deployments -A -o jsonpath='{.items[*].metadata.name}')

# Loop through each deployment and scale it down to 0 replicas
for deployment in $deployments; do
    echo "Scaling DOWN deployment: $deployment"
    kubectl scale deployment "$deployment" --replicas=0
done


if [[ "$CONTINUE" != "" ]]; then
    echo "Scale UP all deployments..."
    deployments=$(kubectl get deployments -A -o jsonpath='{.items[*].metadata.name}')

    # Loop through each deployment and scale it down to 0 replicas
    for deployment in $deployments; do
        echo "Scaling UP deployment: $deployment"
        kubectl scale deployment "$deployment" --replicas=1
        sleep 2
    done

    exit 0
fi

echo "Stopping RKE2..."
systemctl stop rke2-server
sleep 3

echo "Checking stopped ?"
if [[ $(systemctl is-active rke2-server.service) == "active" ]]; then
    echo "RKE2 is running"
    echo "You must stop it!"
    exit 1
else
    echo "RKE2 is not running"
fi

cat << EOF > /etc/rancher/rke2/config.yaml
tls-san:
- rancher.prj.local.net
- $NET_IP
EOF

cat << EOF > /etc/netplan/00-installer-config.yaml
network:
  ethernets:
    $NET_DEVICE:
      dhcp4: no
      addresses: [$NET_IP/24]
      gateway4: $NET_NET_GATEWAY
      nameservers:
        addresses: [$NET_DNS]
  version: 2
EOF

reboot



