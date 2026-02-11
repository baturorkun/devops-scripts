#!/usr/bin/env bash
set -x

cd /root/acme.sh

export AWS_ACCESS_KEY_ID=XXXX
export AWS_SECRET_ACCESS_KEY=XXXX

export LE_WILDCARD="prj.local.net"
echo $LE_WILDCARD
export CERTDIR=/root/rke/certificates_prj
mkdir -p $CERTDIR

./acme.sh --issue -d *.${LE_WILDCARD} --dns dns_aws --days 180 --force


./acme.sh --install-cert -d *.${LE_WILDCARD} --cert-file ${CERTDIR}/cert.pem --key-file ${CERTDIR}/key.pem --fullchain-file ${CERTDIR}/fullchain.pem --ca-file ${CERTDIR}/ca.cer


exit

. /root/rke/set.sh

kubectl -n cattle-system delete secret tls-rancher-ingress
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=${CERTDIR}/fullchain.pem --key=${CERTDIR}/key.pem


NAMESPACES=$(kubectl get ns | awk '{print $1}' | grep -E "(myproject|prj)")

for NS in $NAMESPACES; do
  echo "----------- Apply certs for $NS --------------"
  kubectl -n "$NS" delete secret tls-ingress || true
  kubectl -n "$NS" create secret tls tls-ingress --cert=${CERTDIR}/fullchain.pem --key=${CERTDIR}/key.pem
done

