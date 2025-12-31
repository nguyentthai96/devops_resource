# Opensource Devops collection containers

[![version](https://img.shields.io/badge/version-1.0.0-blue.svg)]()[![download](https://img.shields.io/badge/nexus%20repo-link-brightgreen.svg)](http://10.22.7.126:8081/#browse/search/maven)

Collection setup/configuration containers docker and kubernetes...

------

# Getting Started

### Environment config information:

Require setup:

- Docker engine
- Docker compose version require > 19.03.0

```shell
docker --version
# Docker version 24.0.6, build ed223bc
docker-compose --version
# Docker Compose version v2.3.3
```

Information data domain
- Main domain: nttco.com www.nttco.com > nttdev.com www.nttdev.com
- Test domain: ntthai.com www.ntthai.com > nttthaidev.com
- Personal domain: thaint.net wwww.thaint.net

Ports definition:

- 80, 8080, 443 8443 port http/https
- 8888 is Port dashboard admin proxy traefik (default 8080)
- 3300 is port Grafana (default 3000)

Information data domain

- Main domain: nttco.com www.nttco.com > nttdev.com www.nttdev.com
- Test domain: ntthai.com www.ntthai.com > nttthaidev.com
- Personal domain: thaint.net wwww.thaint.net

Ports definition:

- 80, 8080, 443 8443 port http/https
- 8888 is Port dashboard admin proxy traefik (default 8080)
- 3300 is port Grafana (default 3000)