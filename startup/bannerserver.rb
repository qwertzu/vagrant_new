require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Bannerserver < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')

      # cleaning up some files
      exec_home('rm tmp/pids/thin.pid') # done c

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/redis.yml.example config/redis.yml')
      exec_home('cp -v config/thin.yml.example config/thin.yml')

      # starting/stoping services
      sudo('/etc/init.d/redis-server start')
      #sudo('service apache2 stop')

      # starting the server / services
      exec_home_non_blocking("rvmsudo passenger start -p#{ports[1]} -d --user vagrant -e  #{rails_env} &>/dev/null")
      exec_home("rvmsudo thin start -p#{ports[0]} --user vagrant -e  #{rails_env} -d")
      exec_home("RAILS_ENV=#{rails_env} ruby script/bannerserver_publisher_consumer_daemon start")
    end

    def code_directory
      Settings.bannerserver_path
    end

    def ports
      [80 , 5000]
    end

    def stop
      #TODO implement me!

    end

  end

end