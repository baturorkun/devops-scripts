# aws

podman build -t mynginx .
podman tag mynginx:latest public.ecr.aws/y6a3u3z2/mynginx:latest
aws ecr-public get-login-password --region us-east-1 | podman login --username AWS --password-stdin public.ecr.aws/y6a3u3z2
podman  push public.ecr.aws/y6a3u3z2/mynginx:latest


oc import-image my-nginx --from=public.ecr.aws/y6a3u3z2/mynginx:latest --confirm


# nexus
docker build -t myweb2 .
docker tag myweb:latest 192.168.2.215:9082/myweb2
docker login --username admin --password "TrustNo1*"  192.168.2.215:9082
docker push 192.168.2.215:9082/myweb2