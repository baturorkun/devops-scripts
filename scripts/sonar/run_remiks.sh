#!/bin/bash
set -euxo pipefail


./sonar.sh \
   --git-url="gitlab.mydomain.com/mycompany/myproject/myproject.git" \
   --git-user="batur.orkun" \
   --git-token="MbPG9L-8i76qWFMTHHfz" \
   --git-branch="master" \
   --sonar-login="a2284aa317c2805cd9e47479232e79319a7b580f" \
   --sonar-project-key="myproject" \
   --sonar-host="http://sonarqube.local.net" \
   --run-cmd-before="mvn clean install"