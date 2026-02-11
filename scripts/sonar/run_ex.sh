#!/bin/bash
set -euxo pipefail


./sonar.sh \
   --git-url="bitbucket-gpy.local.net/scm/gpy/7799.git" \
   --git-user="batur.orkun" \
   --git-token="<BITBUCKET_TOKEN>" \
   --git-branch="feature/dev_7799" \
   --sonar-login="<SONAR_TOKEN>" \
   --sonar-project-key="gpy7799" \
   --sonar-host="http://sonarqube.local.net" \
   --sonar-java-binaries="Kurulum/plugins/GPY"



