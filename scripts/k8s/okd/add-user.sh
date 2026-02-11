#!/usr/bin/env bash

if [ -z $1 ]; then
   echo "First parameters must be USERNAME"
   echo "Second parameters must be PASSWORD"
   exit
fi

if [ -z $2 ]; then
   echo "Second parameters must be PASSWORD"
   echo "First parameters must be USERNAME"
   exit
fi

htpasswd -B -b users.htpasswd $1 $2

oc delete secret htpass-secret -n openshift-config
oc create secret generic htpass-secret --from-file=htpasswd=users.htpasswd -n openshift-config

oc apply -f htpasswd.cr

oc adm policy add-cluster-role-to-user cluster-admin $1 --rolebinding-name=cluster-admin
