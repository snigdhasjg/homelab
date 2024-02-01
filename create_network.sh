#!/bin/bash

docker network create \
    -d ipvlan \
    -o parent=eth0 \
    -o ipvlan_mode=l3 \
    -subnet '192.168.74.0/24' \
    homelab

docker network create \
    -d macvlan \
    -o parent=eth0 \
    --subnet '192.168.73.0/24' \
    --gateway '192.168.73.1' \
    --ip-range '192.168.73.192/26' \
    homelab_macvlan