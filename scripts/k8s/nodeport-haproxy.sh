#!/usr/bin/env bash
#set -x

for p in {30000..32000}; do

echo "
frontend nodeport-$p
  bind *:$p
  mode tcp
  option tcplog
  default_backend nodeport-$p

backend nodeport-$p
  mode tcp
  balance roundrobin
  server ocp4-worker01 ocp4-worker01.rehisuygmocp01.mycompany.com.tr:$p check inter 5000 ms
  server ocp4-worker02 ocp4-worker02.rehisuygmocp01.mycompany.com.tr:$p check inter 5000 ms
  server ocp4-worker03 ocp4-worker03.rehisuygmocp01.mycompany.com.tr:$p check inter 5000 ms
  server ocp4-worker04 ocp4-worker04.rehisuygmocp01.mycompany.com.tr:$p check inter 5000 ms
"
done