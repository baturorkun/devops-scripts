
https://kubernetes.io/docs/reference/kubectl/cheatsheet/


Run Container

```
oc run -i --tty --rm  busybox --image=busybox -- sh
```

Kubernetes generator kullanarak deployment yaml dosyası oluşturmak
```
kubectl create deployment test --image nginx --dry-run=client -o yaml
```

