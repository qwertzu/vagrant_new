require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Management < VagrantTest::Service

  class << self

    def run
      sudo('service mysql start')
      exec_home('bundle install')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/database.yml.example config/database.yml')
      exec_home('cp -v config/newrelic.yml.example config/newrelic.yml')
#      exec_home('rake db:create')
      exec_home("RAILS_ENV=#{rails_env} rake db:migrate")
      sudo('ls /etc/apache2')
      sudo('/etc/init.d/redis-server start')
      sudo('/etc/init.d/apache2 start')
    end

    def code_directory
      Settings.management_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end
