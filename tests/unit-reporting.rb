require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  rep = env.add_vm(:reporting)
  rep.add Reporting

  env.test_service = Reporting
  env.rails_env = "vagrant"
  env.spec_path= ['spec/']
end
