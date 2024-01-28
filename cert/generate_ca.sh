#!/bin/bash

set -e

export CERTIFICATE_PATH=${CERTIFICATE_BASEPATH:-./generated}/ca

if [ -d "${CERTIFICATE_PATH}" ]; then
  echo "$CERTIFICATE_PATH exist. Not generating CA"
  exit 1
fi

set -x

mkdir -p ${CERTIFICATE_PATH}
mkdir -p ${CERTIFICATE_PATH}_private

openssl genrsa -aes256 -out ${CERTIFICATE_PATH}_private/ca.key.pem 4096

openssl req \
  -config ${CERTIFICATE_PATH}_private/ca_config.conf \
  -key ${CERTIFICATE_PATH}_private/ca.key.pem \
  -x509 \
  -days 3650 \
  -out ${CERTIFICATE_PATH}/ca.crt.pem
