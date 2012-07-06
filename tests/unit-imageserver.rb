require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  ima = env.add_vm(:imageserver)
  ima.add Imageserver

  env.test_service = Imageserver
  env.rails_env = "vagrant"
  env.spec_path= 'spec/'
end
