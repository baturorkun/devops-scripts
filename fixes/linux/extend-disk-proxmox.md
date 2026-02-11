 Docs
--------
https://pve.proxmox.com/wiki/Resize_disks

https://blog.stevedong.com/post/pve-how-to-extend-ubuntu-no-lvm-disk-in-proxmox-ve/


https://computingforgeeks.com/extending-root-filesystem-using-lvm-linux/


Non LVM
-----------
PVE den UI dan diski buyut

lsblk 

( apt install  cloud-utils )

growpart  /dev/sda 2

or
parted /dev/sda resizepart 3 100%

resize2fs /dev/sda2


LVM
------

Sunucu Disk Space Arttirma  (sda2)

lsblk

growpart /dev/sda 1

parted /dev/sda resizepart 3 100%

pvresize /dev/sda3

lvextend -l +100%FREE  /dev/mapper/ubuntu-vg/ubuntu-lv

or

lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv

resize2fs /dev/ubuntu-vg/ubuntu-lv

resize2fs /dev/ubuntu-vg/ubuntu-lv


lvextend -r -L +49G  /dev/mapper/ubuntu-vg/ubuntu-lv

lsblk

--------------------
lsblk
growpart  /dev/sdg 3
lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs /dev/ubuntu-vg/ubuntu-lv
df -h | grep /$


-----------------
growpart /dev/sda 3
pvresize /dev/sda3
lvextend -l +100%FREE  /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs /dev/ubuntu-vg/ubuntu-lv
df -h | grep /$
