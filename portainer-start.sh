#!/bin/bash

docker stop portainer
docker rm portainer

docker run -d \
    --name portainer \
    --restart always \
    --network homelab \
    --ip 192.168.74.2 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    -v /var/ssl/docker.snigji.com:/cert:ro \
    portainer/portainer-ce:linux-arm64-2.19.4 \
        --http-disabled \
        --bind-https :443 \
        --sslcert /cert/ssl.crt.pem \
        --sslkey /cert/ssl.key.pem
