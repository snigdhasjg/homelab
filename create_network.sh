#!/bin/bash

docker network create \
    -d ipvlan \
    -o parent=eth0 \
    -o ipvlan_mode=l3 \
    --subnet '192.168.74.0/24' \
    homelab_ipvlan_l3

docker network create \
    -d macvlan \
    -o parent=eth0 \
    --subnet '192.168.73.0/24' \
    --gateway '192.168.73.1' \
    --ip-range '192.168.73.192/26' \
    homelab_macvlan

sudo ip link add homelab link eth0 type macvlan mode bridge
sudo ip addr add 192.168.73.250/32 dev homelab
sudo ip link set homelab up
sudo ip route add 192.168.73.192/26 dev homelab

