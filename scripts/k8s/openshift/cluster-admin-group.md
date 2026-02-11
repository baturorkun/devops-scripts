
oc adm groups new mylocaladmins

oc adm policy add-cluster-role-to-group cluster-admin mylocaladmins

oc adm groups add-users mylocaladmins batur.orkun