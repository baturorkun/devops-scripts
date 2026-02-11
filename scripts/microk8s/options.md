

https://github.com/canonical/microk8s/issues/906



option 1

microk8s kubectl delete svc kubernetes-dashboard -n kube-system
microk8s kubectl expose deployment kubernetes-dashboard -n kube-system --type=LoadBalancer --port 8443 --name=kubernetes-dashboard
nodePort=`microk8s kubectl get svc kubernetes-dashboard -n kube-system -o=jsonpath='{.spec.ports[].nodePort}'`
echo https://localhost:$nodePort

open https://localhost:$nodePort in browser

option 2

Define the ingress as mentioned above
run in WSL2 :
sudo apt install openssh-server
sudo systemctl start sshd
sudo ssh -L 127.0.0.1:443:127.0.0.1:443 username@hostname 


option 3
Define the ingress as mentioned here
Run in WSL2 :
sudo apt install openssh-server
sudo systemctl start sshd
sudo ssh -L 127.0.0.1:443:127.0.0.1:443 username@hostname 



127.0.0.1   kubernetes-dashboard.127.0.0.1.nip.io