Error:

MountVolume.MountDevice failed for volume  rpc error: code = Internal desc = format of disk "/dev/longhorn/failed: type:("ext4") target:


Doc:

https://lifesaver.codes/answer/bug-mountvolume-setup-failed-for-volume-~-rpc-error-code-=-internal-desc-=-exit-status-1-due-to-multipathd-on-the-node-1210

Solution:

vi /etc/multipath.conf

Add:
`````
blacklist {
    devnode "^sd[a-z0-9]+"
}
`````

systemctl restart multipathd.service


`````
# lsblk

NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 55.5M  1 loop /snap/core18/2344
loop2                       7:2    0 61.9M  1 loop /snap/core20/1405
loop3                       7:3    0 43.6M  1 loop /snap/snapd/15177
loop4                       7:4    0 67.8M  1 loop /snap/lxd/22753
loop5                       7:5    0 70.3M  1 loop /snap/lxd/21029
loop6                       7:6    0 44.7M  1 loop /snap/snapd/15534
sda                         8:0    0  150G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0  149G  0 part
└─ubuntu--vg-ubuntu--lv 253:0    0  149G  0 lvm  /
sdb                         8:16   0   20G  0 disk /var/lib/kubelet/pods/6501e8b8-54d4-4a2b-909d-16d1795d8828/volume-subpaths/pvc-115041e1-c5af-4142-a1b4-62da7e3b3ee7/postgres/0
sdc                         8:32   0   50M  0 disk
sdd                         8:48   0   50M  0 disk /var/lib/kubelet/pods/73ae60b8-e778-462a-83d0-b6ae93f61535/volumes/kubernetes.io~csi/pvc-06cf49a0-7b2d-4a3c-9386-ca8d843c716b/mount
sde                         8:64   0  150M  0 disk /var/lib/kubelet/pods/ae1039c0-7350-48fa-8ade-98bdfcc6360d/volumes/kubernetes.io~csi/pvc-05fce4c3-d782-442b-9b45-f9a31cde6d76/mount
`````


