# Here is the configuration of virtual machine for servtag.
# This code will be / has been copied from baseboxes/.servtag-postpostinstall.sh to baseboxes/definitions/your_basebox_name/post-installation.sh

# Installation of new software
apt-get install -y libreadline-dev 
apt-get install -y libxml2 libxml2-dev
apt-get install -y apache2.2-common
apt-get install -y redis
apt-get install -y mysql-client mysql-common mysql-server
apt-get install -y couchdb
apt-get install -y rabbitmq-server
#rvm
#cassandra
echo `whoami`
echo `pwd`

# removing /etc/udev/persisent-net.rules

# disabling xserver-xorg

# creating a mysql admin

# symlink in httpd.conf?


