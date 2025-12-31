#!/bin/sh
#

# Hi Mr. Chenda: here path to accept my self certificate file to server local client request in Java code on JVM
# To find path java home, check java runtime
# which java
# whereis java
# ll /usr/bin/java   # -> ll /etc/alternatives/java
JRE_PATH_CERTIFICATE_KEY=/home/mbappserver/jdk-11.0.13+8-jre/lib/security/cacerts
#  /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.201.b09-2.el7_6.x86_64/jre/bin/java -- UAT
mkdir certs

cd certs
## ca.key -> ca_rsa.key -> ca.crt (ssl_client_certificate)
openssl genrsa -des3 -out ca.key 4096
#Remove passphrase for example purposes
openssl rsa -in ca.key -out ca_rsa.key
openssl req -new -x509 -days 3650 -key ca_rsa.key -subj "/CN=*.acledabank.com.kh" -out ca.crt

## server.key (ssl_certificate_key) -> server.csr -> server.crt (ssl_certificate) (server.csr, ca.crt, ca_rsa.key)
printf 12345 > passphrase
openssl genrsa -des3 -passout file:passphrase -out server.key 2048
openssl req -new -passin file:passphrase -key server.key -subj "/CN=*.acledabank.com.kh" -out server.csr

openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca_rsa.key -set_serial 01 -out server.crt

# Only set for JVM call to service domain SSL general by key cert to accept self certificate file that.
keytool -import -v -trustcacerts -file server.crt -alias uat-acledabank -keystore $JRE_PATH_CERTIFICATE_KEY -storepass changeit

## client_rsa_init.key -> client.key (curl --key client.key) -> client.csr -> client.crt (curl --cert client.crt) (client.csr, ca.crt, ca_rsa.key)
printf 12345 > client_passphrase
openssl genrsa -des3 -passout file:client_passphrase -out client_rsa_init.key 2048
openssl rsa -passin file:client_passphrase -in client_rsa_init.key -out client.key
openssl req -new -key client.key -subj "/CN=*.acledabank.com.kh" -out client.csr

##Sign the certificate with the certificate authority
openssl x509 -req -days 365 -in client.csr -CA ca.crt -CAkey ca_rsa.key -set_serial 01 -out client.crt

cd ../


# docker run --rm --name mtls-nginx -p 443:443 \
#  -v $(pwd)/certs/ca.key:/etc/nginx/certs/ca.key \
#  -v $(pwd)/certs/ca.crt:/etc/nginx/certs/ca.crt \
#  -v $(pwd)/certs/ca_rsa.key:/etc/nginx/certs/ca_rsa.key \
#  -v $(pwd)/certs/server.key:/etc/nginx/certs/server.key \
#  -v $(pwd)/certs/server.crt:/etc/nginx/certs/server.crt \
#  -v $(pwd)/nginx.mtls.conf:/etc/nginx/conf.d/nginx.conf \
#  -v $(pwd)/certs/passphrase:/etc/nginx/certs/passphrase nginx


# after config file host domain client /etc/hosts
# 127.0.0.1  apicorporate.acledabank.com.kh

# Testing docker start okay yet
#  curl --key client.key \
#  --cert client.crt \
#  --location --request POST 'https://apicorporate.acledabank.com.kh:8443/api/v1/getAccessTokens' --insecure \
#  --header 'Content-Type: application/json' \
#  --data '{"username":"postbank2021","password":"2021$!CP2ITMX","client_id":"third_party","client_secret":"16681c9ff419d8ecc7cfe479"}' -i -v


# curl --location --request POST 'https://api.acledabank.com.kh/api/v1/getAccessTokens' --insecure \
#  --header 'Content-Type: application/json' \
#  --data '{"username":"postbank2021","password":"2021$!CP2ITMX","client_id":"third_party","client_secret":"16681c9ff419d8ecc7cfe479"}' -i -v


#  curl --key client.key \
#  --cert client.crt \
#  --location --request POST 'https://uat.acledabank.com.kh:8443/api/v1/getAccessTokens' --insecure \
#  --header 'Content-Type: application/json' \
#  --data '{"username":"postbank2021","password":"914bade01fd32493a0f2efc583e1a5f6","client_id":"third_party","client_secret":"16681c9ff419d8ecc7cfe479eb02a7a"}' -i -v

#  curl --location --request POST 'https://uatapicorporate.acledabank.com.kh/api/v1/getAccessTokens' --insecure \
#  --header 'Content-Type: application/json' \
#  --data '{"username":"postbank2021","password":"914bade01fd32493a0f2efc583e1a5f6","client_id":"third_party","client_secret":"16681c9ff419d8ecc7cfe479eb02a7a"}' -i -v