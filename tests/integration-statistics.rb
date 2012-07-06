require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  rab = env.add_vm(:rabbit)
  rab.add Rabbit

  man = env.add_vm(:management)
  man.add Management

  tar = env.add_vm(:targeting)
  tar.add Targeting
  tar.add Dealkeeper

  rep = env.add_vm(:reporting)
  rep.add Reporting

  int = env.add_vm(:integration)
  int.add Integration

  env.test_service = Integration
  env.rails_env = "vagrant"
  env.spec_path= ['spec/statistics']
end
