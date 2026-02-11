#!/usr/bin/env bash

# Warning
echo "I suggest to you do not run the script completely."
echo "I suggest to you do not run the script completely."
echo "This script was written like an MD file because there are various alternatives."
echo "Inspect the file and try to use your selections."
exit


snap install microk8s --classic
# snap remove microk8s 

microk8s.status --wait-ready

microk8s enable dns
microk8s enable rbac
microk8s enable dashboard
microk8s enable storage
microk8s enable ingress
#microk8s enable helm3


# Export KUBECONFIG

microk8s kubectl config view --raw > $HOME/.kube/microk8s.config
export  KUBECONFIG=$HOME/.kube/microk8s.config

# Using Port Forward

# run in Foreground

microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 8443:443 --address 0.0.0.0

# # run in Background
nohup microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 8443:443 --address 0.0.0.0 &


# Open https://IP:8443

# Creating Ingress instead 
# Ingress ile
kubectl apply -f dashboard-ingress.yaml
http://IP/dashboard

# Creating NodePort for dashboard
kubectl -n kube-system edit service kubernetes-dashboard

# Edit > Type : ClusterIP -> NodePort

kubectl describe services kubernetes-dashboard --namespace=kube-system

## Get Nodeport: XXXX ( 31843 )

### https://IP:31843/

# To Login

#  The user is not Admin
token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token

# or For Admin

### Use "KUBECONFIG" file

