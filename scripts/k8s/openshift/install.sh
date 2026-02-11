
ssh-keygen -t rsa -b 4096 -N '' -f id_rsa
eval "$(ssh-agent -s)"
ssh-add id_rsa

# https://github.com/openshift/okd/releases

wget https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-05-22-050008/openshift-client-linux-4.7.0-0.okd-2021-05-22-050008.tar.gz

wget https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-05-22-050008/openshift-install-linux-4.7.0-0.okd-2021-05-22-050008.tar.gz

./openshift-install create cluster --dir=install --log-level info 


ssh core@<Bootstrap-Device-IP>   <--   journalctl -b -f -u release-image.service -u bootkube.service

journalctl -b -f -u release-image.service -u bootkube.service

Install "oc and kubectl"

https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz



"letsencrpt SSL"

https://ksingh7.medium.com/lets-automate-let-s-encrypt-tls-certs-for-openshift-4-211d6c081875

