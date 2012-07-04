require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Frontend < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')

      # starting/stoping services
      sudo('/etc/init.d/redis-server start')
      sudo('/etc/init.d/apache2 stop')

      # starting server
      #exec_home_non_blocking("RACK_ENV=#{rails_env} rack server") # TODO ACHTUNG port?
      #exec_home('daemon -X "rvmsudo middleman -p 80 -e vagrant" ')          # TODO start rake server instead!
      exec_home('RACK_ENV=vagrant rake server &')
      #RACK_ENV=integration rake server
    end

    def code_directory
      Settings.frontend_path
    end

    def ports
      [80, 4567]
    end

    def stop
      #TODO implement me!
    end

  end

end