require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Reporting < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home("bundle install")

      # copying configuration files
      exec_home('cp -v config/couchdb.yml.example config/couchdb.yml')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')

      # starting/stoping server services
      sudo('/etc/init.d/couchdb start')
      sudo('/etc/init.d/apache2 stop')
      sudo('service apache2 stop')

      exec_home_non_blocking("rvmsudo passenger start -p80 -d --user vagrant -e vagrant &>/dev/null")

      # starting the daemons
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/logging.rb start")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/report.rb start")
    end

    def code_directory
      Settings.reporting_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end
