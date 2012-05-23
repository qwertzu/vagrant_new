require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  man = env.add_vm(:management)
  man.add Management

  env.spec_path = '../path_to_spec/'
  env.test_vm = man
end