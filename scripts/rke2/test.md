export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
k  get nodes


NAME   STATUS   ROLES                       AGE   VERSION
rke2   Ready    control-plane,etcd,master   12d   v1.22.7+rke2r2



2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
link/ether 00:50:56:9b:3a:cb brd ff:ff:ff:ff:ff:ff
inet 192.168.10.71/24 brd 192.168.10.255 scope global ens160
valid_lft forever preferred_lft forever
inet 192.168.10.74/32 scope global ens160
valid_lft forever preferred_lft forever
inet6 fe80::250:56ff:fe9b:3acb/64 scope link
valid_lft forever preferred_lft forever



root@rke-node-1:~# k logs $(k get po -n kube-system | grep kube-vip | awk '{print $1}') -n kube-system --tail 1
time="2022-04-12T07:51:26Z" level=info msg="Broadcasting ARP update for 192.168.10.74 (00:50:56:9b:3a:cb) via ens160"



root@rke-node-1:~/certificates# kubectl -n cattle-system rollout status deploy/rancher
Waiting for deployment "rancher" rollout to finish: 0 of 1 updated replicas are available...

root@rke2:~# k get  pods -n cattle-system
NAME                               READY   STATUS    RESTARTS      AGE
rancher-758ccb55bd-zrcrw           1/1     Running   5 (10d ago)   13d
rancher-webhook-5d4f5b7f6d-7v5lf   1/1     Running   2 (10d ago)   13d


kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'

kubectl get nodes

kubectl scale --replicas 3 deployment/rancher -n cattle-system

kubectl get  pods -n cattle-system