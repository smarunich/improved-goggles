#!/bin/bash -e

curl -L https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/provision_vm.sh | bash

cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/provisioning/handle_bootstrap.py
sudo mv /tmp/handle_bootstrap.py /usr/local/bin/
sudo chmod 755 /usr/local/bin/handle_bootstrap.py

cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/provisioning/handle_bootstrap.service
sudo mv /tmp/handle_bootstrap.service /etc/systemd/system/handle_bootstrap.service
systemctl enable handle_bootstrap
systemctl start handle_bootstrap

cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/provisioning/handle_register.py
sudo mv /tmp/handle_register.py /usr/local/bin/
sudo chmod 755 /usr/local/bin/handle_register.py

cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/provisioning/handle_register.service
sudo mv /tmp/handle_register.service /etc/systemd/system/handle_register.service
systemctl enable handle_register
systemctl start handle_register

cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/provisioning/ansible_inventory.py
sudo mv /tmp/ansible_inventory.py /etc/ansible/hosts
sudo chmod 755 /etc/ansible/hosts
git clone git://github.com/ansible/ansible-runner /tmp/ansible-runner
pip install /tmp/ansible-runner/
cp /etc/ansible/hosts /opt/bootstrap/inventory

cd /tmp && curl -O https://raw.githubusercontent.com/smarunich/improved-goggles/master/bootstrap/provisioning/cleanup_controllers.py
sudo mv /tmp/cleanup_controllers.py /usr/local/bin/
sudo chmod 755 /tmp/cleanup_controllers.py

systemctl daemon-reload
systemctl enable redis
systemctl start redis

systemctl enable squid
systemctl start squid

systemctl enable nginx
systemctl start nginx
cp /usr/local/bin/register.py /usr/share/nginx/html/

yum install -y bind-utils vim tmux jq

#Nasty, nasty, very very nasty...
sleep 5
/usr/local/bin/register.py localhost

exit 0