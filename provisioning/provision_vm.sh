#!/bin/bash -e

. /etc/os-release
cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/proxy_blocker.sh
sudo mv /tmp/proxy_blocker.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/proxy_blocker.sh

cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/register.py
sudo mv /tmp/register.py /usr/local/bin/
sudo chmod 755 /usr/local/bin/register.py

curl -L https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/packages.sh | bash
curl -L https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/ansible.sh | bash
curl -L https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/redis.sh | bash

exit 0
