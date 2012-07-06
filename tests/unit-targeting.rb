require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  tar = env.add_vm(:targeting)
  tar.add Targeting

  env.test_service = Targeting
  env.rails_env = "vagrant"
  env.spec_path= 'spec/'
end
