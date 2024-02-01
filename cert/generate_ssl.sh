#!/bin/bash

set -e

read -e -p "Domain name: " -i "test.snigji.com" DOMAIN_NAME
export DOMAIN_NAME
read -e -p "IP address: " -i "192.168.73.200" IP_ADDRESS
export IP_ADDRESS
read -e -p "Application Name: " -i "SnigJi Test" NAME
export NAME

CERTIFICATE_PATH=${CERTIFICATE_BASEPATH:-./generated}/${DOMAIN_NAME}
CA_CERTIFICATE_PATH=${CERTIFICATE_BASEPATH:-./generated}/ca

if [ -d "${CERTIFICATE_PATH}" ]; then
  echo "$CERTIFICATE_PATH exist. Not generating SSL"
  exit 1
fi

mkdir -p ${CERTIFICATE_PATH}

cat ssl_config.conf |\
 awk '{ for (a in ENVIRON) gsub("__" _ a _ "__",ENVIRON[a]); print }' \
 > ${CERTIFICATE_PATH}/ssl_config.conf

openssl req \
  -config ${CERTIFICATE_PATH}/ssl_config.conf \
  -new \
  -newkey rsa:4096 \
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
