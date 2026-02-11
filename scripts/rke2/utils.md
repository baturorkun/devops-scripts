
echo "tls-san:" >> /etc/rancher/rke2/config.yaml
echo "  - rancher.rke.local.net" >> /etc/rancher/rke2/config.yaml
echo "  - rke-node-1.rke.local.net" >> /etc/rancher/rke2/config.yaml
echo "  - rke-node-1" >> /etc/rancher/rke2/config.yaml



mkdir -p $HOME/.kube
export VIP=rancher.rke.local.net
sudo cat /etc/rancher/rke2/rke2.yaml | sed 's/127.0.0.1/'$VIP'/g' > $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config



# update path with rke2-binaries
echo 'export KUBECONFIG=/etc/rancher/rke2/rke2.yaml' >> ~/.bashrc ; echo 'export PATH=${PATH}:/var/lib/rancher/rke2/bin' >> ~/.bashrc ; echo 'alias k=kubectl' >> ~/.bashrc ; source ~/.bashrc ;



kubectl -n cattle-system exec $(kubectl -n cattle-system get pods -l app=rancher | grep '1/1' | head -1 | awk '{ print $1 }') -- reset-password



docker run -d --restart=unless-stopped \
-p 80:80 -p 443:443 --name=rancher-2.4.4 \
-v /opt/rancher:/var/lib/rancher \
rancher/rancher:v2.4.4 --acme-domain rancher.rke.mydomain.com