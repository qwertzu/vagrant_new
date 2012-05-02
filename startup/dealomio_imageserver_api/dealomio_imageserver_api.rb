require 'rubygems'
require 'vagrant'
require 'test_helper.rb'

dir = "/vagrant/imageserver"
server = :imageserver

v=V.new(dir , server)
v.up
#v.sudo('service mysql start')
#v.exec("source ./.rvmrc")
#v.exec("gem install bundler")
v.exec("bundle install")
v.exec('cp -v config/application.yml.example config/application.yml')

v.sudo('/etc/init.d/redis-server start')
v.sudo('/etc/init.d/apache2 start')
v.exec('ruby script/deal_consumer_daemon start')
v.exec('ruby script/detail_picture_consumer_daemon start')
v.exec('ruby script/picture_consumer_daemon start')


#v.exec('rm -rf reports')
#v.exec('RAILS_ENV=test CI_REPORTS=./reports rspec spec --format CI::Reporter::RSpec')
#v.halt


