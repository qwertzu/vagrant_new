require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  tar = env.add_vm(:targeting)
  tar.add Dealkeeper

  env.test_service = Dealkeeper
  env.rails_env = "vagrant"
  env.spec_path= ['spec/']
end
