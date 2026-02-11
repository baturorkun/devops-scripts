gitlab-runner register -n \
--url https://gitlab.mydomain.com/ \
--registration-token 4DC1zNxTCK-SxuzYUb-6 \
--executor docker \
--description "RHV Docker Runner" \
--docker-image "docker:stable" \
--docker-privileged
--docker-volumes /var/run/docker.sock:/var/run/docker.sock

gitlab-runner run
