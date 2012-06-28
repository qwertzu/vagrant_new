require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  ana = env.add_vm(:analytics)
  ana.add Analytics

  env.test_service = Analytics
  env.rails_env = "vagrant"
  env.spec_path= 'spec/'
end
