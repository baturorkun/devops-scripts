#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
    echo "First Parameter: PVC name is required!!!"
    exit
fi

if [[ "$1" == "" ]]; then
    echo "Second parameter : Namespace is required!!!"
    exit
fi

kubectl patch pvc "$1" -p '{"metadata":{"finalizers":null}}' -n $2

kubectl delete pvc "$1"  --grace-period=0 --force -n $2

kubectl patch pv "$1"  -p '{"metadata":{"finalizers":null}}' -n $2

kubectl delete pv "$1" --grace-period=0 --force -n $2
