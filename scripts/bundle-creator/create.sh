#!/usr/bin/env bash

myproject_GIT_TOKEN="kvy8JL_-2af8zGUP5MNM"
myrealm_GIT_TOKEN="4wLrJxLV1y9SxdW2sxbK"

BASEPATH=$(pwd)

git clone https://batur.orkun:${myproject_GIT_TOKEN}@gitlab.mydomain.com/mycompany/myproject/myproject.git
cd myproject
git bundle create myproject.bundle --all
mv myproject.bundle $BASEPATH/myproject.bundle
cd ../
rm -rf myproject

git clone https://batur.orkun:${myproject_GIT_TOKEN}@gitlab.mydomain.com/mycompany/myproject/iac.git
cd iac
git bundle create myproject-iac.bundle --all
mv myproject-iac.bundle $BASEPATH/myproject-iac.bundle
cd ../
rm -rf iac

git clone http://batur.orkun:${myrealm_GIT_TOKEN}@gitlab.local.net/mycompany/myrealm/myrealm.git
cd myrealm
git bundle create myrealm.bundle --all
mv myrealm.bundle $BASEPATH/myrealm.bundle
cd ../
rm -rf myrealm

git clone http://batur.orkun:${myrealm_GIT_TOKEN}@gitlab.local.net/mycompany/myrealm/iac.git
cd iac
git bundle create myrealm-iac.bundle --all
mv myrealm-iac.bundle $BASEPATH/myrealm-iac.bundle
cd ../
rm -rf iac

cd "$BASEPATH"
today=$(date +'%Y-%m-%d')

rm -rf bundles-${today}.tar.gz || true

tar zcvf bundles-${today}.tar.gz *.bundle









