#! /bin/bash

yum install java-1.8.0-openjdk.x86_64 -y
yum update –y
cd /opt/
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar xf latest-unix.tar.gz

mv nexus-3.* nexus3
chown -R ec2-user:ec2-user nexus3/ sonatype-work/
cd /opt/nexus3/bin/
touch nexus.rc
echo 'run_as_user="ec2-user"' | sudo tee -a /opt/nexus3/bin/nexus.rc
ln -s /opt/nexus3/bin/nexus /etc/init.d/nexus
cd /etc/init.d
chkconfig --add nexus
chkconfig --levels 345 nexus on
service nexus start
