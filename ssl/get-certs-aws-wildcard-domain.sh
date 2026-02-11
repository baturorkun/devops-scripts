#!/usr/bin/env bash

# get-certs-aws-wildcard-domain.sh

# params
ACME_DIR="/root/acme.sh"  # ame.sh cloned directory
export AWS_ACCESS_KEY_ID="XXXX"   # aws id
export AWS_SECRET_ACCESS_KEY="XXXX"  # aws secret
export LE_WILDCARD="rke.local.net"  # wildcard domain on AWS
export CERTDIR=/root/certificates  # output directory

mkdir -p $CERTDIR

cd "ACME_DIR"

./acme.sh --issue -d *.${LE_WILDCARD} --dns dns_aws --days 180

./acme.sh --install-cert -d *.${LE_WILDCARD} --cert-file ${CERTDIR}/cert.pem --key-file ${CERTDIR}/key.pem --fullchain-file ${CERTDIR}/fullchain.pem --ca-file ${CERTDIR}/ca.cer
