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
      exec_home('rvmsudo middleman -p 80 -e vagrant')
      # rake server RACK_ENV=integration

    end

    def code_directory
      Settings.banner_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end