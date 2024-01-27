#!/bin/bash

set -e

export DOMAIN_NAME="snigji.com"
export NAME="SnigJi Root CA"
CERTIFICATE_PATH=${CERTIFICATE_BASEPATH:-./generated}/ca

if [ -d "${CERTIFICATE_PATH}" ]; then
  echo "$DIRECTORY exist. Not generating CA"
  exit 1
fi

set -x

mkdir -p ${CERTIFICATE_PATH}
mkdir -p ${CERTIFICATE_PATH}_private

cat ca_config.conf |\
 awk '{ for (a in ENVIRON) gsub("__" _ a _ "__",ENVIRON[a]); print }' \
 > ${CERTIFICATE_PATH}_private/ca_config.conf

openssl genrsa -aes256 -out ${CERTIFICATE_PATH}_private/ca.key.pem 4096

openssl req \
  -config ${CERTIFICATE_PATH}_private/ca_config.conf \
  -key ${CERTIFICATE_PATH}_private/ca.key.pem \
  -x509 \
  -days 3650 \
  -out ${CERTIFICATE_PATH}/ca.crt.pem

chmod -R 700 ${CERTIFICATE_PATH}_private