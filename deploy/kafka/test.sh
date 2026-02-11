#!/usr/bin/env bash

# Alternative: solsson/kafkacat

kubectl run kafta-test -it --image=confluentinc/cp-kafkacat --rm -- "date | kafkacat -b kafka-service:9092 -t sample.topic -P"

kubectl run kafta-test -it --image=confluentinc/cp-kafkacat --rm -- "kafkacat -b kafka-service:9092 -t sample.topic -C"

