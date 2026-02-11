#!/usr/bin/env bash

# NOT :
# bastion host da calisir
# AWS uzerinden  v2.8.9   acme de calisiyor.   v.3.X.X de calismadi verify edemedi TXT leri

cd acme.sh

LE_WILDCARD="dc.mydomain.com"
PLATFORM="dc"

export AWS_ACCESS_KEY_ID=XXXX
export AWS_SECRET_ACCESS_KEY=XXXX

## Ilk defa acme calistirilacak ise yoksa atla
./acme.sh --register-account -m baturorkun@mydomain.com

# aws
./acme.sh --issue  -d *.${LE_WILDCARD} --dns dns_aws

export CERTDIR=/root/$PLATFORM/certificates

mkdir -p $CERTDIR

./acme.sh --install-cert -d *.${LE_WILDCARD} --cert-file ${CERTDIR}/cert.pem --key-file ${CERTDIR}/key.pem --fullchain-file ${CERTDIR}/fullchain.pem --ca-file ${CERTDIR}/ca.cer



scp fullchain.pem  root@192.168.2.218:/etc/ssl/dc.mydomain.com/fullchain.pem

scp key.pem  root@192.168.2.218:/etc/ssl/dc.mydomain.com/key.pem