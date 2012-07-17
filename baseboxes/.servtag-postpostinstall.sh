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
apt-get install -y redis-server #redis-server

# Installing couchdb
apt-get install -y couchdb libcouchdb-glib-1.0-2 python-couchdb gir1.2-couchdb-1.0 couchdb-bin --force-yes
sed -i -e "s/;port = 5984/port = 5984/g" /etc/couchdb/local.ini # explanations: http://opikanoba.org/linux/couchdb-centos6
sed -i -e "s/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/g" /etc/couchdb/local.ini

## Installing a modern version of rabbitmq-server
# Siehe auch: http://www.rabbitmq.com/install-debian.html
echo "" >> /etc/apt/sources.list
echo "# rabbitmq new" >> /etc/apt/sources.list
echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc
apt-get -y update
apt-get install -y rabbitmq-server rabbitmq-plugins-common
rabbitmq-plugins enable rabbitmq_management

## Installing MYSQL - using preseed for automatization
apt-get install -y debconf-utils
echo "mysql-server-5.1 mysql-server/root_password password vagrant" > mysql.preseed
echo "mysql-server-5.1 mysql-server/root_password_again password vagrant" >> mysql.preseed
echo "mysql-server-5.1 mysql-server/start_on_boot boolean true" >> mysql.preseed
cat mysql.preseed | sudo debconf-set-selections
apt-get install -y mysql-server
apt-get install -y mysql-client mysql-common mysql-server

# Installing cassandra
apt-get install -y cassandra --force-yes # starten: sudo services cassandra start
chown -R vagrant /var/log/cassandra # cf: http://dustyreagan.com/installing-cassandraD-on-ubuntu-linux/
chown -R vagrant /var/lib/cassandra

## Installing RVM
# siehe auch: http://stackoverflow.com/questions/10752631/how-to-install-rvm-on-vagrant-ubuntu-12-04-lts-using-puppet
apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion g++
#su vagrant
su vagrant -l -c 'curl -L get.rvm.io > rvm-installer'
su vagrant -l -c 'chmod +x rvm-installer'
su vagrant -l -c './rvm-installer'
su vagrant -l -c 'rvm use 1.9.2-p320 --install'
su vagrant -l -c "rvm use 1.9.2-p320 && gem install bundler rubygems-bundler rvm rake rspec"
su vagrant -l -c "rvm use 1.9.2-p320 && gem install passenger --no-rdoc --no-ri"
su vagrant -l -c "echo 'export rvm_trust_rvmrcs_flag=1' >.rvmrc"
su vagrant -l -c "chmod 664 .rvmrc"

sudo adduser vagrant rvm
sudo adduser root rvm

## Installing dependencies for vagrant_tests
apt-get install -y libqt4-dev libqtwebkit-dev xvfb daemon --force-yes # needed fom gem capybara-webkit
apt-get install -y libmysql-ruby # needed from gem mysql2
apt-get install -y libmagick9-dev # needed from gem rmagick

#node.js
su vagrant -l -c "git clone git://github.com/joyent/node.git"
su vagrant -l -c "cd node && git checkout v0.4.9"
cd node && ./configure && make && make install

cd /home/vagrant/ && echo "v 05.07.2012 am Feierabend " > version

# disabling services at boot
sudo update-rc.d redis-server disable
sudo update-rc.d rabbitmq-server disable
sudo update-rc.d apache2 disable
sudo update-rc.d cassandra disable
sudo update-rc.d couchdb disable

# Starting passenger standalone, because he has to compile, it's long, and we do not want to do it on every VM
# deerty hack
su vagrant -l -c "rvm use 1.9.2@"
su vagrant -l -c "rvmsudo passenger start -p80 -d --user vagrant -e vagrant &>/dev/null"
su vagrant -l -c "rvmsudo passenger stop -p80 &>/dev/null"

## diabling mysql at boot
sudo sed -i -e "s/^start on (net-device-up$//g" /etc/init/mysql.conf
sudo sed -i -e "s/^          and local-filesystems$//g" /etc/init/mysql.conf
sudo sed -i -e "s/and runlevel.*$//g" /etc/init/mysql.conf

# cleaning up
rm *.tar.gz
rm *.tgz
rm *.sh
rm *.preseed
rm rvm-installer
rm -rf node/
