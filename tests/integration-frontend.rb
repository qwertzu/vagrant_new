require File.expand_path(File.dirname(__FILE__) + '/vagrant_helper')

include VagrantTest::DSL

vagrant_test do |env|
  rab = env.add_vm(:rabbit)
  rab.add Rabbit

  man = env.add_vm(:management)
  man.add Management

  ban = env.add_vm(:bannerserver)
  ban.add Bannerserver

  ima = env.add_vm(:imageserver)
  ima.add Imageserver

  ana = env.add_vm(:analytics)
  ana.add Analytics

  int = env.add_vm(:integration)
  int.add Integration

  tar = env.add_vm(:targeting)
  tar.add Targeting
  tar.add Dealkeeper

  feedback = env.add_vm(:feedback)
  feedback.add Feedback

  banner = env.add_vm(:banner)
  banner.add Banner

  frontend = env.add_vm(:frontend)
  frontend.add Frontend

  rep = env.add_vm(:reporting) # TODO to remove
  rep.add Reporting

  env.test_service = Integration
  env.rails_env = "vagrant"
  env.spec_path= ['spec/frontend']

  # RAILS_ENV=vagrant xvfb-run bundle exec rspec spec/frontend/views_spec.rb:45     TODO start frontend tests
end
