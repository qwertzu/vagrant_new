require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Frontend < VagrantTest::Service

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

      # starting service
      sudo('/etc/init.d/redis-server start')

      # starting server
      exec_home("RACK_ENV=#{rails_env} rake server &> /dev/null")
    end

    def code_directory
      Settings.frontend_path
    end

    def ports
      [80, 4567]
    end

    def stop
      sudo('service redis-server stop')
      sudo("ps -ef |grep middleman |grep -v grep | tr -s ' '| cut -d' ' -f 2 | xargs -n 1 sudo kill -9")
    end

  end

end