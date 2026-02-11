# Install RKE


# DNS records

# rke-node-1.rke.local.net
# rke-node-2.rke.local.net
# rke-node-3.rke.local.net
# racher.rke.local.net

# requirements
apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common  nfs-common vim open-iscsi keepalived haproxy

# install docker-ce
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt -y install docker-ce docker-ce-cli containerd.io

## ubuntu

#apt install docker.io

# run commend from bastion host
bastion# ssh-copy-id  rke-node-3.rke.local.net

useradd rke
mkdir -p /home/rke/.ssh
chown rke. /home/rke/.ssh
cp -r /root/.ssh/authorized_keys /home/rke/.ssh/.
chown rke. /home/rke/.ssh/authorized_keys

usermod -aG docker rke


chmod u+w /etc/sudoers
echo "rke  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
chmod u-w /etc/sudoers


wget https://github.com/rancher/rke/releases/download/v1.3.4/rke_linux-amd64


mv rke_linux-amd64 rke
chmod 775 rke
./rke config  --name cluster.yml
./rke up --config  cluster.yml


# check RKE
export KUBECONFIG=/root/rke/kube_config_cluster.yml
kubectl get nodes


# Install HELM
wget https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz
tar zxvf helm-v3.7.1-linux-amd64.tar.gz
mv linux-amd64/helm ../helm

## SSL

## Add DNS "*.rke.local.net" to AWS

export AWS_ACCESS_KEY_ID=XXXX
export AWS_SECRET_ACCESS_KEY=XXXX
export LE_WILDCARD="rke.local.net"
export CERTDIR=/root/rke/certificates

mkdir -p $CERTDIR

cd ../acme
./acme.sh --issue -d *.${LE_WILDCARD} --dns dns_aws
./acme.sh --install-cert -d *.${LE_WILDCARD} --cert-file ${CERTDIR}/cert.pem --key-file ${CERTDIR}/key.pem --fullchain-file ${CERTDIR}/fullchain.pem --ca-file ${CERTDIR}/ca.cer

# Install Rancher
### Create NS & Create Secret

cd /root/rke

#kubectl create namespace cert-manager
#kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.yaml

export CERTDIR=/root/rke/certificates
kubectl create namespace cattle-system
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=${CERTDIR}/fullchain.pem --key=${CERTDIR}/key.pem

kubectl -n cattle-system create secret generic tls-ca  --from-file=${CERTDIR}/cacerts.pem


helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

# helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm fetch rancher-stable/rancher --version=2.6.2

export LE_WILDCARD="rke.mydomain.com"
helm install  rancher rancher-latest/rancher \
    --namespace cattle-system  \
    --set hostname=rancher.${LE_WILDCARD} \
    --set replicas=1 \
    --set ingress.tls.source=secret \
    --set privateCA=true


# wait deploying...
kubectl -n cattle-system rollout status deploy/rancher

kubectl -n cattle-system get deploy rancher

# Wait so long for installation

##### Find Rancher Password
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'


helm repo add longhorn https://charts.longhorn.io
helm repo update
kubectl create namespace longhorn-system
helm install longhorn longhorn/longhorn --namespace longhorn-system
kubectl -n longhorn-system get pod


docker exec -e ETCDCTL_ENDPOINTS=$(docker exec etcd /bin/sh -c "etcdctl member list | cut -d, -f5 | sed -e 's/ //g' | paste -sd ','") etcd etcdctl endpoint health



for endpoint in $(docker exec etcd /bin/sh -c "etcdctl member list | cut -d, -f5"); do
   echo "Validating connection to ${endpoint}/health"
   docker run --net=host -v $(docker inspect kubelet --format '{{ range .Mounts }}{{ if eq .Destination "/etc/kubernetes" }}{{ .Source }}{{ end }}{{ end }}')/ssl:/etc/kubernetes/ssl:ro appropriate/curl -s -w "\n" --cacert $(docker exec etcd printenv ETCDCTL_CACERT) --cert $(docker exec etcd printenv ETCDCTL_CERT) --key $(docker exec etcd printenv ETCDCTL_KEY) "${endpoint}/health"
done


 kubectl delete -n cattle-system MutatingWebhookConfiguration rancher.cattle.io
