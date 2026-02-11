#!/usr/bin/env bash

cd /root/acme.sh

export AWS_ACCESS_KEY_ID=XXXX
export AWS_SECRET_ACCESS_KEY=XXXX

export LE_WILDCARD="grist.local.net"
echo $LE_WILDCARD

./acme.sh --issue -d *.${LE_WILDCARD} --dns dns_aws --days 180 --force

export CERTDIR=/root/rke/certificates_grist
mkdir -p $CERTDIR

./acme.sh --install-cert -d *.${LE_WILDCARD} --cert-file ${CERTDIR}/cert.pem --key-file ${CERTDIR}/key.pem --fullchain-file ${CERTDIR}/fullchain.pem --ca-file ${CERTDIR}/ca.cer
