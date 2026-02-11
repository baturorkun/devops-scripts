#!/usr/bin/env bash

# To delete Terminating status pods in a Namespace
# parameter 1 : Namespace

if [[ "$1" == "" ]]; then
    echo "Namespace parameter is required!"
    exit
fi

kubectl get pods  -n "$1" | grep Terminating | awk '{print $1}' | xargs kubectl  delete pods -n "$1" --force --grace-period=0
