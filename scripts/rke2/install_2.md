### https://ranchermanager.docs.rancher.com/v2.5/how-to-guides/new-user-guides/kubernetes-cluster-setup/rke2-for-rancher



192.168.10.71   rke-node-1.rke.domain.com
192.168.10.72   rke-node-2.rke.domain.com
192.168.10.73   rke-node-3.rke.domain.com
192.168.10.74   rke-node-4.rke.domain.com
192.168.10.75   rke-node-5.rke.domain.com

192.168.10.79   rancher.rke.domain.com


# From Node-1

mkdir -p /etc/rancher/rke2
vi /etc/rancher/rke2/config.yaml

tls-san:
- rke-node-1
- rke-node-1.rke.mydomain.com
- rancher.rke.mydomain.com
- 192.168.10.51
- 192.168.10.59


##  curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.22 sh -

## curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=v1.29.0+rke2r1 sh -
curl -sfL https://get.rke2.io | sh -

systemctl enable rke2-server
systemctl start rke2-server


export VIP=192.168.2.29
export TAG=v0.5.7
export INTERFACE=ens19
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

# From bastion host

snap install helm --classic

kubectl create namespace cattle-system

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update


-----------
## With CertManager 
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
k get pods -n cert-manager


helm install rancher rancher-latest/rancher \
--namespace cattle-system \
--set hostname=rancher.rke.local.net \
--set replicas=3

-----------
## With Ready SSL certificate

export CERTDIR=/root/rke/certificates_local
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=${CERTDIR}/fullchain.pem --key=${CERTDIR}/key.pem

helm upgrade --install  rancher rancher-latest/rancher \
--namespace cattle-system  \
--set hostname=rancher.rke.mydomain.com \
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

token: K10cf99b69cff5a0568fc262e5c3dcbb9d30d7ed02de174a53e0d0b90ba17061eb7::server:61474f2b4f288c8171c08abca095a7dd
server: https://rancher.rke.mydomain.com:9345
tls-san:
- rke-node-2
- rke-node-2.rke.mydomain.com
- rancher.rke.mydomain.com
- 192.168.2.22
- 192.168.2.29



# curl -sfL https://get.rke2.io | sh -

curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=v1.24.9+rke2r1 sh -

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
- rke-node-2
- rke-node-2.rke.local.net
- rancher.rke.local.net
- 192.168.10.73
- 192.168.10.74



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
--set hostname=rancher.rke.mydomain.com \
--set replicas=5 \
--set ingress.tls.source=secret

helm upgrade --install  rancher rancher-latest/rancher \
--namespace cattle-system  \
--set hostname=rancher.rke.local.net \
--set replicas=5 \
--set ingress.tls.source=secret


# Uninstall

/usr/local/bin/rke2-uninstall.sh
