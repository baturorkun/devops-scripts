LDAP i inactive yapmak icin

```
docker exec -it -u www-data  <APP CONTAINER ID>  php /var/www/html/occ  ldap:set-config s01 ldapConfigurationActive 0
```


LDAP i active yapmak icin

```
docker exec -it -u www-data  <APP CONTAINER ID>  php /var/www/html/occ  ldap:set-config s01 ldapConfigurationActive 1
```

