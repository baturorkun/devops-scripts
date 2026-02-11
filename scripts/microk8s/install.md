snap install microk8s --classic
# snap remove microk8s 

microk8s.status --wait-ready

microk8s enable dns
microk8s enable rbac
microk8s enable dashboard
microk8s enable storage
microk8s enable ingress
#microk8s enable helm3

microk8s kubectl config view --raw > $HOME/.kube/microk8s.config
export  KUBECONFIG=$HOME/.kube/microk8s.config

#export  KUBECONFIG=/root/microk8s/kube.config

# Port Forward ile acma
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 8443:443 --address 0.0.0.0
nohup microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 8443:443 --address 0.0.0.0 &
https://IP:8443

# Ingress ile
kubectl apply -f dashboard-ingress.yaml
http://IP/dashboard

# Node Port ile
kubectl -n kube-system edit service kubernetes-dashboard
Edit > Type : ClusterIP -> NodePort

kubectl describe services kubernetes-dashboard --namespace=kube-system

Get Nodeport: XXXX ( 31843 )

https://192.168.2.41:31843/

# Giris icin

# Admin Olmayan

token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token

# or For Admin

Use "KUBECONFIG" file

