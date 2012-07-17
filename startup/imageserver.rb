require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Imageserver < VagrantTest::Service

  class << self

    def init
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')
    end

    def run
      # solving a bug with capybara
      exec_home("daemon -X 'Xvfb :1 -screen 0 1024x768x16 -nolisten inet6' --name=xserver-simator-daemon --inherit -env=RAILS_ENV=vagrant ")

      init #TODO remove when init-start-stop funktioniert

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')

      # starting/stoping services
      sudo('/etc/init.d/redis-server start')

      # starting server
      exec_home_non_blocking("RAILS_ENV=#{rails_env} rvmsudo passenger start -p#{ports[0]} -d --user vagrant -e #{rails_env} &>/dev/null")

      # starting the daemons
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/deal_consumer_daemon start")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/detail_picture_consumer_daemon start")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/picture_consumer_daemon start")
    end

    def code_directory
      Settings.imageserver_path
    end

    def ports
      [80]
    end

    def stop
      exec_home("ps -edf | grep Xvfb | grep -v grep | tr -s ' '| cut -d ' ' -f 2 | xargs -n 1 sudo kill -9")
      sudo('/etc/init.d/redis-server stop')
      exec_home_non_blocking("RAILS_ENV=#{rails_env} rvmsudo passenger stop -p#{ports[0]}")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/deal_consumer_daemon stop")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/detail_picture_consumer_daemon stop")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/picture_consumer_daemon stop")
    end

  end

end