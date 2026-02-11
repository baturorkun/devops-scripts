oc create route edge syndesisoperator  \
--service=syndesis-operator-metrics \
--cert=fullchain.pem \
--key=key.pem \
--hostname=syndesis.c2.okd.code2.dev \
--insecure-policy=Redirect -n prealpha
