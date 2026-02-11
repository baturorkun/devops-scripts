#!/usr/bin/env bash

# To delete Terminating status pods in a Namespace
# parameter 1 : Namespace

if [[ "$1" == "" ]]; then
    echo "Namespace parameter is required!"
    exit
fi

kubectl delete pods --field-selector status.phase=Failed -n "$1"