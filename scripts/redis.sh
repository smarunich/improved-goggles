#!/bin/bash -e

. /etc/os-release

if [ "$ID" == "centos" ] || [ "$ID" == "rhel" ]; then
    echo "*Running for CentOS or RHEL"
    sudo sed -i 's/^\(bind 127.0.0.1\)$/#\1/' /etc/redis.conf
    sudo sed -i 's/^\(protected-mode\) yes/\1 no/' /etc/redis.conf
elif [ "$ID" == "kali" ]; then
    echo "*Running for Kali Linux"
    sudo service redis-server stop
    sudo systemctl disable redis-server
fi
