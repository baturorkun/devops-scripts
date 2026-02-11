#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
    echo "NS parameter is required!"
    exit
fi

kubectl get pods  -n "$1" | grep Error | awk '{print $1}' | xargs kubectl  delete pods -n "$1"