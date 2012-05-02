require 'rubygems'
require 'vagrant'
require 'test_helper.rb'

dir = "/vagrant/integration"
server = :integration

v=V.new(dir , server)
v.up
#v.sudo('service mysql start')
#v.exec("source ./.rvmrc")
#v.exec("gem install bundler")
v.exec("bundle install")
v.exec('cp -v config/application.yml.example config/application.yml')
v.sudo('/etc/init.d/apache2 start')
#v.exec('rm -rf reports')
#v.exec('RAILS_ENV=test CI_REPORTS=./reports rspec spec --format CI::Reporter::RSpec')
v.exec("RAILS_ENV=vagrant bundle exec rspec spec/deals/deals_spec.rb")
v.halt


