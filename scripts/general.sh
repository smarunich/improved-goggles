#!/bin/bash -e

. /etc/os-release
cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/scripts/proxy_blocker.sh
sudo mv /tmp/proxy_blocker.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/proxy_blocker.sh

cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/scripts/register.py
sudo mv /tmp/register.py /usr/local/bin/
sudo chmod 755 /usr/local/bin/register.py
