require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Banner < VagrantTest::Service

  class << self

    def init
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')
    end

    def run
      init #TODO remove when init-start-stop funktioniert

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')

      # starting server
      exec_home("RACK_ENV=#{rails_env} rake server &> /dev/null")
    end

    def code_directory
      Settings.banner_path
    end

    def ports
      [80, 3030]
    end

    def stop
      sudo("ps -ef |grep middleman |grep -v grep | tr -s ' '| cut -d' ' -f 2 | xargs -n 1 sudo kill -9")
    end

  end
end