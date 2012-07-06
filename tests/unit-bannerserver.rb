require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  ban = env.add_vm(:bannerserver)
  ban.add Bannerserver

  env.test_service = Bannerserver
  env.rails_env = "vagrant"
  env.spec_path= ['spec/']
end
