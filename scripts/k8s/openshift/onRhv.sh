
https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz

curl -k -u admin@internal:XXXXXXXX https://rhvm.mydomain.com/ovirt-engine/api

api.ocp.mydomain.com	 192.168.2.46
*.apps.ocp.mydomain.com	192.168.2.47


curl -k 'https://<engine-fqdn>/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA' -o /tmp/ca.pem


sudo chmod 0644 /tmp/ca.pem


sudo cp -p /tmp/ca.pem /etc/pki/ca-trust/source/anchors/ca.pem

sudo update-ca-trust

ssh-keygen -t rsa -b 4096 -N '' -f id_rsa
eval "$(ssh-agent -s)"
ssh-add id_rsa

wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz

wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz


Engine URL: rhvm.mydomain.com



./openshift-install gather bootstrap --dir=co --bootstrap 192.168.2.146 --master "192.168.2.147 192.168.2.148 192.168.2.149"


oc get csr -o name | xargs oc adm certificate approve

