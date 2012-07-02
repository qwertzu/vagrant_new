require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Feedback < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')

      # starting server
      #exec_home_non_blocking("RACK_ENV=vagrant rvmsudo rackup -p 80 --user vagrant -e vagrant")            # TODO neue / port
      # rackup -p 3003
      exec_home_non_blocking("RAILS_ENV=#{rails_env} rvmsudo passenger -p 80 --user vagrant -e vagrant")

    end

    def code_directory
      Settings.feedback_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end