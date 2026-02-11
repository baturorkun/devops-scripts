kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.1


kubectl get pods --namespace cert-manager




kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml


kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.2/cert-manager.yaml

kubectl create namespace cattle-system

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update


helm upgrade rancher rancher-stable/rancher \
  --namespace cattle-system \
  --version 2.6.3 \
  --set hostname=rancher.rke.local.net \
  --set replicas=1




helm upgrade rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.rke.mydomain.com \
  --set bootstrapPassword=batur \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=batur.orkun@mydomain.com \
  --set letsEncrypt.ingress.class=nginx


kubectl -n cattle-system rollout status deploy/rancher