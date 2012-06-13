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
#apt-get install -y apache2 #apache2-mpm-worker apache2-prefork-dev apache2-utils apache2.2-bin apache2.2-common
apt-get install -y redis #redis-server
apt-get install -y couchdb python-couchdb
apt-get install -y rabbitmq-server

## Installing MYSQL - using preseed for automatization
apt-get install -y debconf-utils
echo "mysql-server-5.1 mysql-server/root_password password vagrant1" > mysql.preseed
echo "mysql-server-5.1 mysql-server/root_password_again password vagrant1" >> mysql.preseed
echo "mysql-server-5.1 mysql-server/start_on_boot boolean true" >> mysql.preseed
cat mysql.preseed | sudo debconf-set-selections
apt-get -y install mysql-server
apt-get install -y mysql-client mysql-common mysql-server
apt-get install cassandra	# starten: sudo services cassandra start

## Installing RVM
# siehe auch: http://stackoverflow.com/questions/10752631/how-to-install-rvm-on-vagrant-ubuntu-12-04-lts-using-puppet
sudo su vagrant
apt-get -y install curl gcc git-core libyaml-dev libsqlite3-dev libxml2-dev libxslt-dev libc6-dev ncurses-dev subversion
su vagrant
curl -L get.rvm.io | bash -s stable
#PATH=$PATH:/usr/local/rvm/bin
#echo "gem: --no-ri --no-rdoc" | tee /home/vagrant/.gemrc > /root/.gemrc
#rvm install 1.9.2-p320
#rvm alias create default 1.9.2-p320
#source /usr/local/rvm/environments/default
#rvm install 1.9.2-p320
#rvm use 1.9.2-p320
sudo adduser vagrant rvm

## ruby version
su vagrant
rvm install 1.9.2-p320
rvm use 1.9.2-p320
gem install bundler rubygems-bundler rvm rake
echo "export rvm_trust_rvmrcs_flag=1" >.rvmrc
chmod 664 .rvmrc

# rvm-alternatif from http://pyfunc.blogspot.de/2011/11/creating-base-box-from-scratch-for.html
# curl -s https://rvm.beginrescueend.com/install/rvm -o rvm-installer
# chmod +x rvm-installer
# sudo ./rvm-installer --version latest

#node.js
#wget 'http://nodejs.org/dist/v0.6.19/node-v0.6.19.tar.gz'
#tar -zxvf node-v0.6.19.tar.gz
# make test

# cleaning up
rm *.tar.gz
rm *.tgz
rm *.sh
rm *.preseed

# removing /etc/udev/persisent-net.rules
#sed -i -e 's/^SUBSYSTEM/^#SUBSYSTEM/g' /etc/udev/rules.d/70-persistent-cd.rules # *cd oder *rules?

# disabling xserver-xorg
