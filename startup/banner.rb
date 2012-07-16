require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Banner < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')

      # starting server
      #exec_home_non_blocking("RACK_ENV=vagrant rvmsudo rackup server --user vagrant -e vagrant")
      #exec_home('daemon -X "rvmsudo middleman -p 80 -e vagrant"')
      exec_home("daemon -X 'rake server' --chdir=/vagrant/#{self.name} --env='RACK_ENV=#{rails_env}' --errlog=/vagrant/#{self.name}-log-err --dbglog=/vagrant/#{self.name}-log-log2 --output= vagrant/#{self.name}-out --stdout=/vagrant/#{self.name}-out2 --stderr=/vagrant/#{self.name}-err")
      # rake server RACK_ENV=integration

    end

    def code_directory
      Settings.banner_path
    end

    def ports
      [80, 3030]
    end

    def stop
      #TODO implement me!
    end

  end

end