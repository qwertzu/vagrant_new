require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  rab = env.add_vm(:rabbit)
  rab.add Rabbit

  tar = env.add_vm(:targeting)
  tar.add Targeting

  ana = env.add_vm(:analytics)
  ana.add Analytics

  int = env.add_vm(:integration)
  int.add Integration

  env.test_service = Integration
  env.rails_env = "vagrant"
  env.spec_path= ['spec/analytics']
  env.ci_rep = "./../reports"
  env.format = "CI::Reporter::RSpec"
end
