#!/bin/bash

set -e

read -e -p "Domain name: " -i "test.snigji.com" DOMAIN_NAME
export DOMAIN_NAME
read -e -p "Primary IP address: " -i "192.168.74.200" PRIMARY_IP_ADDRESS
export PRIMARY_IP_ADDRESS
read -e -p "Secondary IP address: " -i "192.168.73.200" SECONDARY_IP_ADDRESS
export SECONDARY_IP_ADDRESS
read -e -p "Application Name: " -i "SnigJi Test" NAME
export NAME

CERTIFICATE_PATH=${CERTIFICATE_BASEPATH:-./generated}/${DOMAIN_NAME}
CA_CERTIFICATE_PATH=${CERTIFICATE_BASEPATH:-./generated}/ca

mkdir -p ${CERTIFICATE_PATH}

if find "${CERTIFICATE_PATH}" -mindepth 1 -maxdepth 1 | read >> /dev/null 2>&1; then
  echo "$CERTIFICATE_PATH exist. Not generating SSL"
  exit 1
fi

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
  -days 360 \
  -in ${CERTIFICATE_PATH}/ssl.csr \
  -CA ${CA_CERTIFICATE_PATH}/ca.crt.pem \
  -CAkey ${CA_CERTIFICATE_PATH}_private/ca.key.pem \
  -out ${CERTIFICATE_PATH}/ssl.crt.pem \
  -extfile ${CERTIFICATE_PATH}/ssl_config.conf \
  -extensions v3_server \
  -CAserial ${CA_CERTIFICATE_PATH}/ca.crt.srl
  # -CAcreateserial # for the 1st time use this

openssl pkcs12 \
  -export \
  -out ${CERTIFICATE_PATH}/ssl.p12 \
  -passout pass: \
  -inkey ${CERTIFICATE_PATH}/ssl.key.pem \
  -in ${CERTIFICATE_PATH}/ssl.crt.pem