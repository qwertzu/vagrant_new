#require 'rubygems'
#require 'vagrant'
#require 'test_helper.rb'
#
#dir = "/vagrant/targeting"
#server = :targeting
#
#v=V.new(dir , server)
#v.up
#v.exec("bundle install")
#v.exec('cp -v config/redis.yml.example config/redis.yml')
#v.exec('cp -v config/application.yml.example config/application.yml')
#v.exec('cp -v config/logcaster.yml.example config/logcaster.yml')
##v.exec('rm -rf reports')
##v.exec('CI_REPORTS=./reports RACK_ENV=production rspec spec --format CI::Reporter::RSpec')
#v.sudo('/etc/init.d/redis-server start')
#v.sudo('/etc/init.d/apache2 start')
#v.exec('ruby script/targeting_publisher_consumer_daemon start')
#
#
#v.dir = '/vagrant/dealkeeper'
#
#v.exec('cp -v config/dealkeeper.yml.example config/dealkeeper.yml')
#v.exec('bundle install')
#v.exec('RAILS_ENV=vagrant bundle exec ruby script/start.rb start')
#v.halt

