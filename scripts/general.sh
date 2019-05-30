#!/bin/bash -e

. /etc/os-release

sudo cp /tmp/internal-root /root/.ssh/id_rsa
sudo chown root.root /root/.ssh/id_rsa
sudo chmod 600 /root/.ssh/id_rsa

sudo ssh-keygen -yf /tmp/internal-root | sudo tee -a /root/.ssh/authorized_keys > /dev/null
sudo rm /tmp/internal-root

sudo mv /tmp/proxy_blocker.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/proxy_blocker.sh

sudo mv /tmp/register.py /usr/local/bin/
sudo chmod 755 /usr/local/bin/register.py

if [ "$ID" == "centos" ] || [ "$ID" == "rhel" ]; then
    echo "*Running for CentOS or RHEL"
    sudo tar -zxvf /tmp/avinetworks.tar.gz -C /usr/share/nginx
    sudo rm /tmp/avinetworks.tar.gz
elif [ "$ID" == "kali" ]; then
    echo "*Running for Kali Linux"
    sudo systemctl enable cloud-final
fi
