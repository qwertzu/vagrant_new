require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Targeting < VagrantTest::Service

  class << self

    def run
      exec_home("bundle install")
      exec_home('cp -v config/redis.yml.example config/redis.yml')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')
      sudo('/etc/init.d/redis-server start')
      sudo('/etc/init.d/apache2 start')
      exec_home('ruby script/targeting_publisher_consumer_daemon start')
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

