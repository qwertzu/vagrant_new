# Here is the configuration of virtual machine for servtag.
# This code will be or has been copied from baseboxes/.servtag-postpostinstall.sh to baseboxes/definitions/your_basebox_name/post-installation.sh

echo ""
echo ""
echo "Welcome to the Servtag's postinstall script"
echo "==========================================="
echo ""

#######################################################
# variables
#
#######################################################
#last_command_exit_status=0
#current_task=""

#######################################################
# Helpers
#
#######################################################
#function exec_with_info (){
#
#}

#function clean_with (){
#$last_command_exit_status=0
#$current_task=""
#}


# Installing new SOFTWARES and necessary servers
apt-get -y update
apt-get -y upgrade
apt-get install -y libreadline-dev 
apt-get install -y libxml2 libxml2-dev
apt-get install -y apache2.2-common
apt-get install -y redis-server
apt-get install -y couchdb
apt-get install -y rabbitmq-server

## Installing MYSQL - using preseed for automatization
apt-get install -y debconf-utils
echo "mysql-server-5.1 mysql-server/root_password password vagrant" > mysql.preseed
echo "mysql-server-5.1 mysql-server/root_password_again password vagrant" >> mysql.preseed
echo "mysql-server-5.1 mysql-server/start_on_boot boolean true" >> mysql.preseed
cat mysql.preseed | sudo debconf-set-selections
apt-get -y install mysql-server
apt-get install -y mysql-client mysql-common mysql-server


## Installing RVM
##	siehe auch https://rvm.io/rvm/install/
apt-get install -y curl
sudo su vagrant
cd
echo `pwd`
curl -L get.rvm.io | bash -s stable --rubyapti	
echo `which rvm`
echo "end of: installing rvm - starting: installing cassandra"

#cassandra - from cassandra*.tar.gz README
echo `pwd`
wget http://www.apache.org/dyn/closer.cgi?path=/cassandra/1.1.1/apache-cassandra-1.1.1-bin.tar.gz
tar -zxvf apache-cassandra-1.1.1-bin.tar.gz
sudo mkdir -p /var/log/cassandra
sudo chown -R `whoami` /var/log/cassandra
sudo mkdir -p /var/lib/cassandra
sudo chown -R `whoami` /var/lib/cassandra

echo `whoami`	#root
echo `pwd`	#/tmp   !


# removing /etc/udev/persisent-net.rules
#sed -i -e 's/^SUBSYSTEM/^#SUBSYSTEM/g' /etc/udev/rules.d/70-persistent-cd.rules # *cd oder *rules?

# disabling xserver-xorg

# creating a mysql admin

# symlink in httpd.conf?


