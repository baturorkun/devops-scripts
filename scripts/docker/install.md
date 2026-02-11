
usermod -aG docker

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# debian
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# ubuntu
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list


sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo groupadd docker

sudo usermod -aG docker root


sudo curl -L https://github.com/docker/compose/releases/download/v2.11.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod 777 /usr/local/bin/docker-compose