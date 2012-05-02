require 'rubygems'
require 'vagrant'
require 'test_helper.rb'

dir = "/vagrant/analytics"
server = :analytics

v=V.new(dir , server)
v.up
#v.sudo('service mysql start')
#v.exec("source ./.rvmrc")
#v.exec("gem install bundler")
v.exec("bundle install")
v.exec('cp -v config/application.yml.example config/application.yml')
v.exec('cp -v config/couchdb.yml.example config/couchdb.yml')
v.exec('cp -v config/logcaster.yml.example config/logcaster.yml')

#v.exec('RAILS_ENV=test rake db:drop')
#v.exec('RAILS_ENV=test rake db:create')
#v.exec('RAILS_ENV=vagrant rake db:migrate')
v.sudo('/etc/init.d/couchdb start')
v.sudo('/etc/init.d/apache2 start')
v.exec('ruby script/analytics_consumer_daemon.rb start')

#v.exec('rm -rf reports')
#v.exec('RAILS_ENV=test CI_REPORTS=./reports rspec spec --format CI::Reporter::RSpec')
#v.halt


