
bash cleaner.sh \
  --nexus-user="admin" \
  --nexus-passwd="TrustNo1*" \
  --nexus-url="https://nexus.mydomain.com" \
  --gitlab-url="https://gitlab.mydomain.com" \
  --gitlab-project-id=2 \
  --gitlab-token="7G84C_keT-d7Ap-RfBB9" \
  --nexus-keep-tags-list="latest" \
  --nexus-keep-tags="2\.(.*)\.(.*)" \
  --nexus-keep-tags="1\.(.*)\.(.*)" \
  --nexus-filter-images="^myproject-.*$" \
  --nexus-docker-repository="docker-hosted"



bash cleaner.sh \
  --nexus-user="admin" \
  --nexus-passwd="TrustNo1*" \
  --nexus-url="https://nexus.mydomain.com" \
  --gitlab-url="http://gitlab.local.net" \
  --gitlab-token="mLB1se3QyCixRQA4Pbns" \
  --gitlab-project-id=7 \
  --nexus-keep-tags-list="latest" \
  --nexus-keep-tags="1\.(.*)\.(.*)" \
  --nexus-filter-images="^myrealm-.*$" \
  --nexus-docker-repository="docker-hosted"


bash cleaner.sh \
  --nexus-user="admin" \
  --nexus-passwd="TrustNo1*" \
  --nexus-url="https://nexus.mydomain.com" \
  --gitlab-url="http://gitlab.local.net" \
  --gitlab-token="zyXKFSxTMxVwEeHgxZ1V" \
  --gitlab-project-id=2 \
  --nexus-keep-tags-list="latest" \
  --nexus-keep-tags="1\.(.*)\.(.*)" \
  --nexus-filter-images="^example-.*$" \
  --nexus-docker-repository="docker-hosted"


