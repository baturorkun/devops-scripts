RKE2 commands

https://gist.github.com/kingsd041/5b4e454fe6f63552be19cfb81f3753ea


# Eger node  ip si degisirse

systemctl stop rke2-server

#rke2 certificate rotate  # bu calismadi gibi

rke2 server --cluster-reset
systemctl start rke2-server



# butun depoyment lari restart

kubectl rollout restart deployment --namespace prj-demo-svc


# butun deployment lari scale down
kubectl scale deployment -n prj-demo-svc  --replicas=0  --all


# butun deployment lari scale up
kubectl scale deployment -n prj-demo-svc  --replicas=1  --all