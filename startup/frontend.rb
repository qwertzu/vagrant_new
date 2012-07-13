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

      # starting/stoping services
      sudo('/etc/init.d/redis-server start')
      #sudo('/etc/init.d/apache2 stop')

      # starting server
      #exec_home_non_blocking("RACK_ENV=#{rails_env} rack server") # TODO ACHTUNG port?
      #exec_home('daemon -X "rvmsudo middleman -p 80 -e vagrant" ')          # TODO start rake server instead!
      exec_home("daemon -X 'RACK_ENV=#{rails_env} rake server' --chdir=/vagrant/#{@name} --env='RAILS_ENV=@{rail_env}' --errlog=/vagrant/#{@name}-log-err --dbglog=/vagrant/#{@name}-log-log2 --output= vagrant/#{@name}-out --stdout=/vagrant/#{@name}-out2 --stderr=/vagrant/#{@name}-err")
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