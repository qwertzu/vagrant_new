require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Targeting < VagrantTest::Service

  class << self

    def run
      exec_home("gem install bundler")
      exec_home("bundle install")
      exec_home('cp -v config/redis.yml.example config/redis.yml')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')
      sudo('/etc/init.d/redis-server start')

      #sudo('/etc/init.d/apache2 start')

      sudo('lsof -i :80 > /home/vagrant/port-used')
      exec_home_non_blocking("RAILS_ENV=#{rails_env} rvmsudo passenger start -p4567 --user=vagrant &")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby dealomio_targeting.rb -p 80 &")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/targeting_publisher_consumer_daemon start &")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/targeting_adspace_consumer_daemon start &")

      #File f =

    end

    def code_directory
      Settings.targeting_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end

