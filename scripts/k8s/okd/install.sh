ssh-keygen -t rsa -b 4096 -N '' -f id_rsa
eval "$(ssh-agent -s)"
ssh-add id_rsa
./openshift-install create cluster --dir=install --log-level info 

./openshift-install destroy cluster --dir=install


Install "oc and kubectl"

https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz


"letsencrpt SSL"

https://ksingh7.medium.com/lets-automate-let-s-encrypt-tls-certs-for-openshift-4-211d6c081875

"App with TLS"

https://www.openshift.com/blog/create-https-based-encrypted-urls-using-routes


https://github.com/RedHatWorkshops/welcome-php
