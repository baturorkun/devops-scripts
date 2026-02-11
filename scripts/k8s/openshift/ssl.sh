#!/usr/bin/env bash

# NOT :
# AWS uzerinden  v2.8.9   acme de calisiyor.   v.3.X.X de calismadi verify edemedi TXT leri

export AWS_ACCESS_KEY_ID=XXXX
export AWS_SECRET_ACCESS_KEY=XXXX

## Ilk defa acme calistirilacak ise yoksa atla
./acme.sh --register-account -m baturorkun@mydomain.com


export LE_API=$(oc whoami --show-server | cut -f 2 -d ':' | cut -f 3 -d '/' | sed 's/-api././')
echo $LE_API


export LE_WILDCARD=$(oc get ingresscontroller default -n openshift-ingress-operator -o jsonpath='{.status.domain}')
echo $LE_WILDCARD

cd acme.sh
# aws
./acme.sh --issue -d ${LE_API} -d *.${LE_WILDCARD} --dns dns_aws

#./ssh-dc.sh --issue -d ${LE_API} -d *.${LE_WILDCARD} --dns  --yes-I-know-dns-manual-mode-enough-go-ahead-please

# Add TXT to DNS
# ignore for AWS
#./ssh-dc.sh --renew -d ${LE_API} -d *.${LE_WILDCARD}  --yes-I-know-dns-manual-mode-enough-go-ahead-please

# export CERTDIR=/root/okd-stg/certificates
export CERTDIR=/root/ocp/certificates

mkdir -p $CERTDIR

./acme.sh --install-cert -d *.${LE_WILDCARD} --cert-file ${CERTDIR}/cert.pem --key-file ${CERTDIR}/key.pem --fullchain-file ${CERTDIR}/fullchain.pem --ca-file ${CERTDIR}/ca.cer

oc create secret tls router-certs --cert=${CERTDIR}/fullchain.pem --key=${CERTDIR}/key.pem -n openshift-ingress

# oc create secret tls router-certs --cert=${CERTDIR}/fullchain.pem --key=${CERTDIR}/key.pem -n openshift-ingress --dry-run -o yaml | oc replace -f -

oc patch ingresscontroller default -n openshift-ingress-operator --type=merge --patch='{"spec": { "defaultCertificate": { "name": "router-certs" }}}'

#oc patch apiserver cluster --type=merge -p '{"spec":{"servingCerts": {"namedCertificates": [{"names": ["api.dev.mydomain.com"], "servingCertificate": {"name": "router-certs"}}]}}}'

oc get po -n openshift-ingress

oc get route -n openshift-console

