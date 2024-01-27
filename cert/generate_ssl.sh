#!/bin/bash

set -x

export DOMAIN_NAME="docker.snigji.com"
export IP_ADDRESS="192.168.74.2"
export NAME="SnigJi Docker UI"

mkdir -p tmp

cat ssl_config.conf.tpl |\
 awk '{ for (a in ENVIRON) gsub("__" _ a _ "__",ENVIRON[a]); print }' \
 > "tmp/${DOMAIN_NAME}.conf"
cat ssl_signing.conf.tpl |\
  awk '{ for (a in ENVIRON) gsub("__" _ a _ "__",ENVIRON[a]); print }' \
  > "tmp/${DOMAIN_NAME}_signing.conf"

openssl genrsa -out "tmp/${DOMAIN_NAME}.key" 4096

openssl req \
  -config "tmp/${DOMAIN_NAME}.conf" \
  -new \
  -key "tmp/${DOMAIN_NAME}.key" \
  -out "tmp/${DOMAIN_NAME}.csr"

openssl x509 \
  -req \
  -sha256 \
  -days 3650 \
  -in "tmp/${DOMAIN_NAME}.csr" \
  -CA /home/joe/.cert/ca.crt \
  -CAkey /home/joe/.cert/ca-key.pem \
  -out "tmp/${DOMAIN_NAME}.single.crt" \
  -extfile "tmp/${DOMAIN_NAME}_signing.conf" \
  -CAserial /home/joe/.cert/ca.srl 
  # -CAcreateserial # for the 1st time use this

cat "tmp/${DOMAIN_NAME}.single.crt" >> "tmp/${DOMAIN_NAME}.crt"
# cat ca.crt > "tmp/${DOMAIN_NAME}.crt"

mkdir -p /home/joe/.cert/${DOMAIN_NAME}
mv "tmp/${DOMAIN_NAME}.crt" /home/joe/.cert/${DOMAIN_NAME}/
mv "tmp/${DOMAIN_NAME}.key" /home/joe/.cert/${DOMAIN_NAME}/

rm -rf tmp
