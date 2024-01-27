#!/bin/bash

openssl genrsa -aes256 -out ca-key.pem 4096

openssl req \
  -config ca_config.conf \
  -key ca-key.pem \
  -x509 \
  -days 3650 \
  -out ca.pem
