#!/bin/bash
if [ ! -f "./cert" ]; then
  mkdir -p "./cert"
#  https://gist.github.com/Kmaschta/205a67e42421e779edd3530a0efe5945
  openssl req -x509 -newkey rsa:2048 -nodes -keyout ./cert/certificate.key -out ./cert/certificate.crt -days 365 \
     -subj "/C=VN/ST=Vietnamese/L=Ho Chi Minh/O=NTTCo/OU=IT/CN=www.nttco.com"
fi

if ! docker secret inspect portainer.sslcert &> /dev/null; then
  docker secret create portainer.sslcert ./cert/certificate.crt
  docker secret create portainer.sslkey ./cert/certificate.key
fi

docker stack deploy -c portainer-agent-stack.yml portainer
sleep 3
# docker service inspect --format '{{ range .Spec.TaskTemplates }}{{ if eq .Mode.Name "replicated" }}{{ .ContainerSpec.Name }}{{ .ContainerSpec.DNSConfig.Domain }}{{ end }}{{ end }}' portainer
#open https://localhost:9443