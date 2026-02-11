
Open
https://console.redhat.com/openshift/install/vsphere/installer-provisioned

Download installer and tools


Installation Manuel:

https://docs.openshift.com/container-platform/4.9/installing/installing_vsphere/installing-vsphere.html

Installation Video:

https://www.youtube.com/watch?v=gYnVPcc6oMs

----
1
Once Cert lar yuklenmeli

wget --no-check-certificate  https://vcenter.local.net/certs/download.zip

unzip download.zip

for centos:

cp certs/lin/* /etc/pki/ca-trust/source/anchors
update-ca-trust extract


for debian:

Debian da uzantilar mutlaka .crt olmasi gerekiyor. O sebeple ".crt" uzantisi eklenmeli  dosyalara

cd certs/lin
find . -type f -exec mv '{}' '{}'.crt \;
cp  *  /usr/local/share/ca-certificates/
update-ca-certificates

----
2

Create SSH key
ssh-keygen -t ed25519 -N ''


3
cd /root/ocp
./openshift-install create install-config --dir=ipi

```
root@bastion:~/ocp# ./openshift-install install-config cluster --dir=ipi
? SSH Public Key /root/.ssh/id_ed25519.pub
? Platform vsphere
? vCenter vcenter.local.net
? Username administrator@vsphere.local
? Password [? for help] *********
INFO Connecting to vCenter vcenter.mydomain.com
INFO Defaulting to only available datacenter: vSAN Datacenter
INFO Defaulting to only available cluster: vSAN Cluster
INFO Defaulting to only available datastore: vsanDatastore
INFO Defaulting to only available network: VM Network
? Virtual IP Address for API 192.168.10.46
? Virtual IP Address for Ingress 192.168.2.47
? Base Domain local.net
? Cluster Name ocp
```

vi ipi/install-config.yaml

Makinaların cpu ve ram ve diskleri değiştirilebilir.

Workers:

platform:
  vsphere:
    cpus: 2
    coresPerSocket: 2
    memoryMB: 16384
    osDisk:
      diskSizeGB: 240

Masters:

platform:
  vsphere:
    cpus: 4
    coresPerSocket: 2  
    memoryMB: 32768
    osDisk:
      diskSizeGB: 240

---
3.
./openshift-install create cluster --dir=ipi --log-level info




