#! /bin/bash

# install ansible
yum-config-manager --enable epel
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install epel-release-latest-7.noarch.rpm
yum update -y
yum install python python-devel python-pip openssl ansible -y

sudo su -
sudo useradd ansibleadmin
sudo echo "ansibleansible" | passwd --stdin ansibleadmin
echo 'ansibleadmin     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo 'ec2-user     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service sshd restart