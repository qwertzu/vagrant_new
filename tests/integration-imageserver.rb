require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  rab = env.add_vm(:rabbit)
  rab.add Rabbit

  man = env.add_vm(:management)
  man.add Management

  ban = env.add_vm(:bannerserver)
  ban.add Bannerserver

  ban2 = env.add_vm(:banner)
  ban2.add Banner

  ima = env.add_vm(:imageserver)
  ima.add Imageserver

  int = env.add_vm(:integration)
  int.add Integration

  env.test_service = Integration
  env.rails_env = "vagrant"
  env.spec_path= ['spec/imageserver']
end
