#! /bin/bash

    useradd ansibleadmin
    echo "ansibleansible" | passwd --stdin ansibleadmin
    echo 'ansibleadmin     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
    echo 'ec2-user     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers 
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    service sshd restart

    yum update -y

    amazon-linux-extras install docker -y
    service docker start 
    usermod -a -G docker ansibleadmin
	sudo systemctl enable docker
    sudo yum install python2-pip
    sudo pip2 install docker-py