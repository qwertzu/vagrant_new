require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  geo_db = env.add_vm(:maxmind_geo_db)
  geo_db.add Maxmind_geo_db

  env.test_service = Maxmind_geo_db
  env.rails_env = "vagrant"
  env.spec_path= ['spec/']
end
