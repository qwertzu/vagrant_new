require File.expand_path(File.dirname(__FILE__) + './../lib/vagrant_tests')
require File.expand_path(File.dirname(__FILE__) + './../startup/dealomio_management_api/dealomio_management_api')

include VagrantTest::DSL

 vagrant_test do |env|
    man = env.add_vm('name')
    man.add Management

   env.spec_path= '../path_to_spec/'
   env.test_vm= man
 end