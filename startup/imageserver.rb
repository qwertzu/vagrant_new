require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Imageserver < VagrantTest::Service

  class << self

    def run
      # solving a bug with capybara
      exec_home("daemon -X 'Xvfb :1 -screen 0 1024x768x16 -nolisten inet6' --name=xserver-simator-daemon --inherit -env=RAILS_ENV=vagrant ")

      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')

      # starting/stoping services
      sudo('/etc/init.d/redis-server start')
      #sudo('/etc/init.d/apache2 stop')

      # starting server
      exec_home_non_blocking("RAILS_ENV=#{rails_env} rvmsudo passenger start -p80 -d --user vagrant -e vagrant &>/dev/null")

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
      #TODO implement me!
    end

  end

end