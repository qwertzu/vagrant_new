require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Dealkeeper < VagrantTest::Service

  class << self

    def init
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')
    end

    def run
      init #TODO remove when init-start-stop funktioniert

      # copying configuration files
      exec_home('cp -v config/dealkeeper.yml.example config/dealkeeper.yml')

      # starting the service
      exec_home("RAILS_ENV=#{rails_env} bundle exec ruby script/start.rb start &")
    end

    def code_directory
      Settings.dealkeeper_path
    end

    def ports
      [6767]
    end

    def stop
      #TODO implement me!
    end

  end

end