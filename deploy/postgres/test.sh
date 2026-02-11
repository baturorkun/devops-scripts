#!/usr/bin/env bash

kubectl run pgsql-postgresql-client --rm --tty -i --restart='Never' \
--namespace batur --image docker.io/bitnami/postgresql:11.7.0-debian-10-r9  \
--env="PGPASSWORD=94509450" --command -- psql --host postgres -U postgres -d postgres -p 5432

#--env="PGPASSWORD=demopostgrespwd" --command -- psql --host postgres -U demopostgresadmin -d demopostgresdb -p 5432

