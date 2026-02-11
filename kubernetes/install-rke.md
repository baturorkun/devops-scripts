# Here are RKE installation notes.
### The Resource from RKE: https://ranchermanager.docs.rancher.com/v2.5/how-to-guides/new-user-guides/kubernetes-cluster-setup/rke2-for-rancher

# My Nodes and DNS records ( 5 nodes for me )
# If you want to create a cluster,  you need a min 3 nodes.
# But it is possible to install  single node RKE
# Set these IPs to nodes statically

192.168.10.71   rke-node-1.rke.domain.com
192.168.10.72   rke-node-2.rke.domain.com
192.168.10.73   rke-node-3.rke.domain.com
192.168.10.74   rke-node-4.rke.domain.com
192.168.10.75   rke-node-5.rke.domain.com


# This is VIP ( Virtual IP or Floating IP )
192.168.10.79   rancher.rke.domain.com

# I suggest that copy your ssh key to all nodes

# Connect to First Node ( ssh root@rke-node-1.rke.domain.com)

mkdir -p /etc/rancher/rke2
vi /etc/rancher/rke2/config.yaml

tls-san:
- rke-node-1
- rke-node-1.rke.local.net
- rancher.rke.local.net
- 192.168.10.71
- 192.168.10.79

curl -sfL https://get.rke2.io | sh -

## That curl will get the latest stable RKE2 version.
## If you want to get a specific version of RKE,  you can use the one below.
## curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=v1.24.11+rke2r1 sh -

systemctl enable rke2-server
systemctl start rke2-server


export VIP=192.168.10.79
export TAG=v0.5.10
export INTERFACE=ens160
export CONTAINER_RUNTIME_ENDPOINT=unix:///run/k3s/containerd/containerd.sock
export CONTAINERD_ADDRESS=/run/k3s/containerd/containerd.sock
export PATH=/var/lib/rancher/rke2/bin:$PATH
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
alias k=kubectl


curl -s https://kube-vip.io/manifests/rbac.yaml > /var/lib/rancher/rke2/server/manifests/kube-vip-rbac.yaml
crictl pull docker.io/plndr/kube-vip:$TAG
alias kube-vip="ctr --namespace k8s.io run --rm --net-host docker.io/plndr/kube-vip:$TAG vip /kube-vip"

kube-vip manifest daemonset \
--arp \
--ddns \
--interface $INTERFACE \
--address $VIP \
--controlplane \
--leaderElection \
--taint \
--services \
--inCluster | tee /var/lib/rancher/rke2/server/manifests/kube-vip.yaml



sleep 10

k logs $(k get po -n kube-system | grep kube-vip | awk '{print $1}') -n kube-system --tail 1


ip a list $INTERFACE

snap install helm --classic 

kubectl create namespace cattle-system

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update


-----------

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
k get pods -n cert-manager


helm install rancher rancher-latest/rancher \
--namespace cattle-system \
--set hostname=rancher.rke.local.net \
--set replicas=3

-----------

export CERTDIR=/root/rke/certificates_local
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=${CERTDIR}/fullchain.pem --key=${CERTDIR}/key.pem

helm upgrade --install  rancher rancher-latest/rancher \
--namespace cattle-system  \
--set hostname=rancher.rke.local.net \
--set replicas=3 \
--set ingress.tls.source=secret


--version 2.6.3 \
------------
Upgrade:
helm get values rancher -n cattle-system -o yaml > values.yaml
helm upgrade rancher rancher-latest/rancher \
--namespace cattle-system \
-f values.yaml \
--version=2.6.5



kubectl -n cattle-system rollout status deploy/rancher

or

kubectl -n cattle-system  get pods -w


# Get Token

cat /var/lib/rancher/rke2/server/token



Node 2
---------

mkdir -p /etc/rancher/rke2
vi /etc/rancher/rke2/config.yaml


token: K106aa3609121f255f7c2c679470ee1681844c922027ab987e04075ba5161db145d::server:a85a24a151c052fb18832ad986e07c66
server: https://rancher.rke.local.net:9345
tls-san:
- rke-node-2
- rke-node-2.rke.local.net
- rancher.rke.local.net
- 192.168.10.72
- 192.168.10.79



curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server
systemctl start rke2-server


journalctl -u rke2-server -f


Node 3
---------

mkdir -p /etc/rancher/rke2
vi /etc/rancher/rke2/config.yaml


token: K10218ff358fb1d3fa9eec109d3350e54840482ea309046767a841f931c8fe81ef9::server:cebe6146e15a8d4d1186929ac56677b8
server: https://rancher.rke.local.net:9345
tls-san:
- rke-node-4
- rke-node-4.rke.local.net
- rancher.rke.local.net
- 192.168.10.74
- 192.168.10.79



curl -sfL https://get.rke2.io | sh -

systemctl enable rke2-server
systemctl start rke2-server


journalctl -u rke2-server -f

##################################

# Scale UP

kubectl scale deployment/rancher --namespace cattle-system --replicas=3 


# Install Longhorn

helm repo add longhorn https://charts.longhorn.io
helm repo update
kubectl create namespace longhorn-system
helm install longhorn longhorn/longhorn --namespace longhorn-system

kubectl -n longhorn-system get pod



# Fixes


kubectl delete -A ValidatingWebhookConfiguration rke2-ingress-nginx-admission



### Upgrade New Version

helm upgrade rancher rancher-stable/rancher -n cattle-system --reuse-values --set replicas=1

helm upgrade rancher rancher-stable/rancher -n cattle-system --reuse-values --set replicas=3


helm upgrade --install  rancher rancher-latest/rancher \
--namespace cattle-system  \
--set hostname=rancher.rke.domain.com.tr \
--set replicas=3 \
--set ingress.tls.source=secret

# --set antiAffinity=required \

helm upgrade --install  rancher rancher-latest/rancher \
--namespace cattle-system  \
--set hostname=rancher.rke.local.net \
--set antiAffinity=required \
--set replicas=5 \
--set ingress.tls.source=secret


# Uninstall

/usr/local/bin/rke2-uninstall.sh

Install NFS CSI Driver

curl -skSL https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/install-driver.sh | bash -s master --
