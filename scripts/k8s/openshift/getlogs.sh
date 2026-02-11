dd#!/usr/bin/env bash

LOGS=$(/root/ocp/oc adm node-logs --role=master --path=kube-apiserver/)

# shellcheck disable=SC1073
for line in $LOGS
do
  if [[ $line == *".log"* ]]; then
      echo "run $line"
      /root/ocp/oc adm node-logs $node --path=kube-apiserver/$line > logs/kube-apiserver-$line
  fi

  echo ">>>Node: $line"
  node=$line

done
