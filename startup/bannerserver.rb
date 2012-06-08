require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Bannerserver < VagrantTest::Service

  class << self

    def run
      exec_home("gem install bundler")
      exec_home('bundle install')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/redis.yml.example config/redis.yml')
      exec_home('cp -v config/thin.yml.example config/thin.yml')
      sudo('/etc/init.d/redis-server start')
      exec_home("RAILS_ENV=#{rails_env} thin start -d -p 5000 &")
      exec_home("RAILS_ENV=#{rails_env} thin start -d -p 5001 &")
      exec_home("RAILS_ENV=#{rails_env} ruby script/bannerserver_publisher_consumer_daemon start")
      sudo('/etc/init.d/apache2 start')
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