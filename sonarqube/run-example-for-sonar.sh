#!/bin/bash
set -euxo pipefail

./sonar.sh \
   --git-url="gitlab.domain.com/group/name/name.git" \
   --git-user="batur.orkun" \
   --git-token="EHBG9L-34GHH8NJNM78" \
   --git-branch="master" \
   --sonar-login="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
   --sonar-project-key="MYPROJECT" \
   --sonar-host="http://sonarqube.domain.com" \
   --run-cmd-before="mvn clean install"