require 'rubygems'
require 'vagrant'
require 'test_helper.rb'

dir = "/vagrant/management"
server = :rabbit

v=V.new(dir , server)
v.up
v.exec('less /etc/hosts')
v.exec('less /vagrant/Vagrantfile')
v.sudo('/etc/init.d/rabbitmq-server stop')
v.sudo('/etc/init.d/rabbitmq-server start')
#v.halt


