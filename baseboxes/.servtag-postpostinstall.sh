# Here is the configuration of virtual machine for servtag.
# This code will be or has been copied from baseboxes/.servtag-postpostinstall.sh to baseboxes/definitions/your_basebox_name/post-installation.sh
# It will be executed at the end of the basebox installation

echo ""
echo ""
echo "Welcome to the Servtag's postinstall script"
echo "==========================================="
echo ""

# updating source.list
echo "deb http://www.apache.org/dist/cassandra/debian 08x main" >> /etc/apt/sources.list
echo "deb-src http://www.apache.org/dist/cassandra/debian 08x main" >> /etc/apt/sources.list

# Installing new SOFTWARES and necessary servers
apt-get -y update
apt-get -y upgrade
apt-get install -y libreadline-dev 
apt-get install -y libxml2 libxml2-dev
apt-get install -y apache2-mpm-prefork apache2-prefork-dev libcurl4-openssl-dev libapr1-dev libaprutil1-dev #für phusion passenger
apt-get install -y redis #redis-server
apt-get install -y couchdb python-couchdb
apt-get install -y rabbitmq-server

## Installing MYSQL - using preseed for automatization
apt-get install -y debconf-utils
echo "mysql-server-5.1 mysql-server/root_password password vagrant" > mysql.preseed
echo "mysql-server-5.1 mysql-server/root_password_again password vagrant" >> mysql.preseed
echo "mysql-server-5.1 mysql-server/start_on_boot boolean true" >> mysql.preseed
cat mysql.preseed | sudo debconf-set-selections
apt-get -y install mysql-server
apt-get install -y mysql-client mysql-common mysql-server
apt-get install cassandra	# starten: sudo services cassandra start


## Installing RVM
# siehe auch: http://stackoverflow.com/questions/10752631/how-to-install-rvm-on-vagrant-ubuntu-12-04-lts-using-puppet
apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion g++
#su vagrant
su vagrant -l -c 'curl -L get.rvm.io > rvm-installer'
su vagrant -l -c 'chmod +x rvm-installer'
su vagrant -l -c './rvm-installer'
su vagrant -l -c 'rvm use 1.9.2-p320 --install'
su vagrant -l -c "rvm use 1.9.2-p320 && gem install bundler rubygems-bundler rvm rake rspec"
su vagrant -l -c "echo 'export rvm_trust_rvmrcs_flag=1' >.rvmrc"
su vagrant -l -c "chmod 664 .rvmrc"

sudo adduser vagrant rvm
sudo adduser root rvm

## Installing dependencies for vagrant_tests
apt-get install -y libqt4-dev libqtwebkit-dev #needed fom gem capybara-webkit
apt-get install -y libmysql-ruby	      #needed from gem mysql2 ... ist eigentlich libmysql-ruby1.8
apt-get install -y libmagick9-dev

#node.js
#wget 'http://nodejs.org/dist/v0.6.19/node-v0.6.19.tar.gz'
#tar -zxvf node-v0.6.19.tar.gz
# make test

# cleaning up
rm *.tar.gz
rm *.tgz
rm *.sh
rm *.preseed
rm rvm-installer
