#!/usr/bin/env bash

curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt install nodejs
node -v
ln -s /usr/bin/node /usr/bin/nodejs
