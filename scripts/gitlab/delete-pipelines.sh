#!/bin/bash
set -e

TOKEN="<Yarattığımız gitlab token'ı, profilden yaratın.>"
PROJECT="2" (Proje id si)
# How many to delete from the oldest. (Son 1000 taneyi siler)
PER_PAGE=1000

for PIPELINE in $(curl --header "PRIVATE-TOKEN: $TOKEN" "https://gitlab.mydomain.com/api/v4/projects/$PROJECT/pipelines?per_page=$PER_PAGE&sort=asc" | jq '.[].id') ; do
    echo "Deleting pipeline $PIPELINE"
    curl --header "PRIVATE-TOKEN: $TOKEN" --request "DELETE" "https://gitlab.mydomain.com/api/v4/projects/$PROJECT/pipelines/$PIPELINE"
done
