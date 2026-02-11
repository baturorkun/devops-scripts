# My proxmox disk is lvm named "local-lvm"
# 134 is VM ID
# FILE.qcow2  is my external file from getting another platform

qm importdisk 134 FILE.qcow2 local-lvm