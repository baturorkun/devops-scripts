https://access.redhat.com/solutions/3419001

NGINX pod fails to start 

```
2021/09/30 11:58:47 [warn] 1#1: the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:2
nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:2
2021/09/30 11:58:47 [emerg] 1#1: mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)
nginx: [emerg] mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)
```

### Solution:

PROJECT="myrealm"
oc adm policy add-scc-to-user anyuid system:serviceaccount:$PROJECT:default




Denenmedi ???

    template:
      spec:
        serviceAccountName: anyuid
