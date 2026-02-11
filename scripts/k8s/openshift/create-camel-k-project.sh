 
 oc login --token=sha256~u8nt4y4KEK8AuPwceJgdlkkAeD2z6E0xmUUYRmD3gqw --server=https://api.cluster3.batur.code2.dev:6443

 oc new-project camelk-rest
 
 kamel install --olm=false --skip-cluster-setup --skip-operator-setup --maven-repository https://jitpack.io@id=jitpack@snapshots

