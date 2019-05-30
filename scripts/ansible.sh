#!/bin/bash -e

. /etc/os-release

if [ "$ID" == "centos" ] || [ "$ID" == "rhel" ]; then
    echo "*Running for CentOS or RHEL"
    sudo sed -i 's/^#\(host_key_checking = False\)/\1/' /etc/ansible/ansible.cfg
fi
