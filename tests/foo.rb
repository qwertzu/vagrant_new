require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  rab = env.add_vm(:rabbit)
  rab.add Rabbit

  man = env.add_vm(:management)
  man.add Management

  #tar = env.add_vm(:targeting)
  #tar.add Targeting
  #tar.add Dealkeeper

  ban = env.add_vm(:bannerserver)
  ban.add Bannerserver

  #ima = env.add_vm(:imageserver)
  #ima.add Imageserver

  #ana = env.add_vm(:analytics)
  #ana.add Analytics

  #feedback = env.add_vm(:feedback)
  #feedback.add Feedback

  #banner = env.add_vm(:banner)
  #banner.add Banner

  #frontend = env.add_vm(:frontend)
  #frontend.add Frontend

  #rep = env.add_vm(:reporting)
  #rep.add Reporting

  int = env.add_vm(:integration)
  int.add Integration


  env.test_service = Integration
  env.rails_env = "vagrant"
  env.spec_path = ['spec/deals/deals_spec.rb']
  env.ci_rep = "./../reports"
  env.format = "CI::Reporter::RSpec"
end
