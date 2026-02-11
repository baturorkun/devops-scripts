
# ocp

oc process -f deployconfig-template.yaml -p APP=myweb3 | oc create -f -
oc import-image myweb3 --confirm --all --scheduled --from nexus.mydomain.com/myweb3
oc rollout latest dc/myweb3
oc expose svc/myweb3