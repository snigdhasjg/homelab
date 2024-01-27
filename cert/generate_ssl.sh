#!/bin/bash

set -e
set -x

export DOMAIN_NAME="adguard.snigji.com"
export IP_ADDRESS="192.168.74.100"
export NAME="SnigJi AdGuard Home"
CERTIFICATE_PATH=${CERTIFICATE_BASEPATH:-./generated}/${DOMAIN_NAME}
CA_CERTIFICATE_PATH=${CERTIFICATE_BASEPATH:-./generated}/ca

rm -rf ${CERTIFICATE_PATH}
mkdir -p ${CERTIFICATE_PATH}

cat ssl_config.conf |\
 awk '{ for (a in ENVIRON) gsub("__" _ a _ "__",ENVIRON[a]); print }' \
 > ${CERTIFICATE_PATH}/ssl_config.conf

openssl req \
  -config ${CERTIFICATE_PATH}/ssl_config.conf \
  -new \
  -newkey rsa:2048 \
  -keyout ${CERTIFICATE_PATH}/ssl.key.pem \
  -out ${CERTIFICATE_PATH}/ssl.csr

openssl x509 \
  -req \
  -days 3650 \
  -in ${CERTIFICATE_PATH}/ssl.csr \
  -CA ${CA_CERTIFICATE_PATH}/ca.crt.pem \
  -CAkey ${CA_CERTIFICATE_PATH}_private/ca.key.pem \
  -out ${CERTIFICATE_PATH}/ssl.crt.pem \
  -extfile ${CERTIFICATE_PATH}/ssl_config.conf \
  -extensions v3_server \
  -CAserial ${CA_CERTIFICATE_PATH}/ca.crt.srl
  # -CAcreateserial # for the 1st time use this
