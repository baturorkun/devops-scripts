https://rancher.com/docs/rancher/v2.x/en/installation/resources/k8s-tutorials/ha-rke/




kubectl create namespace cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.2/cert-manager.crds.yaml



kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=fullchain.pem --key=key.pem

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system

helm upgrade rancher rancher-latest/rancher   --namespace cattle-system   --set hostname=rancher.rke.mydomain.com --set controller.service.type=LoadBalancer  --set ingress.tls.source=secret  --set tls=external

template2helm convert --template stateful-template.yaml --chart ~/tmp/charts


helm install --dry-run --debug  ~/tmp/charts/postgres-stateful-template --set docker_repo=nexus.mydomain.com/ --set storage_cls=longhorn --generate-name


helm install postgres ~/tmp/charts/postgres-stateful-template --set docker_repo=nexus.mydomain.com/ --set storage_cls=longhorn


Bunlardan birisi yuklu olmali storage icin;

apt install nfs-common
?
apt install nfs-kernel-server





https://medium.com/@gregory.grubbs/putting-up-a-rancher-kubernetes-cluster-on-bare-metal-dce3b8ac2a4a


