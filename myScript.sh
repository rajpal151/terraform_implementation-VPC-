
yum install java-1.8.0-openjdk.x86_64 -y

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum install jenkins -y

systemctl start jenkins

systemctl enable jenkins
chkconfig jenkins on

service jenkins status