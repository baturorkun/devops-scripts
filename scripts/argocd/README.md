
Initial  Admin Password


```

kubectl -n argocd get secret argocd-cluster -o jsonpath='{.data.admin\.password}' | base64 -d

```

Change Admin Password

```

$ kubectl -n argocd patch secret example-argocd-cluster \
-p '{"stringData": {
"admin.password": "newpassword2021"
}}'

```


oc adm policy add-cluster-role-to-user cluster-admin -z argocd-application-controller -n argocd