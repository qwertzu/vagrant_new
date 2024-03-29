require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Targeting < VagrantTest::Service

  class << self

    def init
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')
    end

    def run
      init #TODO remove when init-start-stop funktioniert

      # copying configuration files
      exec_home('cp -v config/redis.yml.example config/redis.yml')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')

      # starting/stoping services
      sudo('/etc/init.d/redis-server start')

      # starting the server / service
      exec_home("rvmsudo passenger start -p#{ports[0]} -d --user vagrant -e #{rails_env} &> /dev/null")
      exec_home("RAILS_ENV=#{rails_env} rvmsudo ruby dealomio_targeting.rb -p #{ports[1]} &")

      # starting the daemons
      exec_home("RAILS_ENV=#{rails_env} ruby script/targeting_publisher_consumer_daemon start")
      exec_home("RAILS_ENV=#{rails_env} ruby script/targeting_adspace_consumer_daemon start")
    end

    def code_directory
      Settings.targeting_path
    end

    def ports
      [80, 3001]
    end

    def stop
      # starting/stoping services
      sudo('/etc/init.d/redis-server stop')

      # starting the server / service
      exec_home("rvmsudo passenger stop -p#{ports[0]}")
      # exec_home("RAILS_ENV=#{rails_env} rvmsudo ruby dealomio_targeting.rb -p #{ports[1]} &")
      # TODO kill dealomio_targeting.rb

      # starting the daemons
      exec_home("RAILS_ENV=#{rails_env} ruby script/targeting_publisher_consumer_daemon stop")
      exec_home("RAILS_ENV=#{rails_env} ruby script/targeting_adspace_consumer_daemon stop")
    end

  end

end
