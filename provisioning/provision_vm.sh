#!/bin/bash -e

. /etc/os-release

yum remove -y firewalld
yumcmd="sudo yum install -y"
subscriptioncmd="sudo subscription-manager repos"
aptcmd="sudo DEBIAN_FRONTEND=noninteractive apt-get -y install"

if [ "$ID" == "centos" ] || [ "$ID" == "rhel" ]; then
    echo "*Running for CentOS or RHEL"
    if [ "$ID" == "rhel" ]; then
        sudo rpm -ihv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    fi
    cmd=$yumcmd
    $cmd epel-release
    $cmd ansible
    sudo sed -i 's/^#\(host_key_checking = False\)/\1/' /etc/ansible/ansible.cfg
    $cmd git
    $cmd nginx
    $cmd python-pip
    $cmd bind
    $cmd redis
    $cmd python-redis
    $cmd squid
    $cmd docker
    $cmd python-devel
    sudo yum groupinstall -y 'Development Tools'
    sudo pip install avisdk
    sudo pip install awscli
    sudo pip install boto3
    sudo pip install docker
    sudo ansible-galaxy install avinetworks.avisdk
    sudo ansible-galaxy install avinetworks.aviconfig
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
    $cmd azure-cli
elif [ "$ID" == "kali" ]; then
    echo "*Running for Kali Linux"
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
    #sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" upgrade
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
    cmd=$aptcmd
    $cmd redis
    $cmd python-redis
    sudo pip install awscli
fi





exit 0
