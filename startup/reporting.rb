require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Reporting < VagrantTest::Service

  class << self

    def init
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')
    end

    def run
      init #TODO remove when init-start-stop funktioniert

      # copying configuration files
      exec_home('cp -v config/couchdb.yml.example config/couchdb.yml')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')

      # starting/stoping server services
      sudo('service couchdb start')

      exec_home_non_blocking("rvmsudo passenger start -p#{ports[0]} -d --user vagrant -e #{rails_env} &>/dev/null")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby dealomio_reporting_api.rb start -p 3001 &")

      # starting the daemons
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby scripts/logging.rb start")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby scripts/report.rb start")
    end

    def code_directory
      Settings.reporting_path
    end

    def ports
      [80, 5984]
    end

    def stop
      sudo('service couchdb stop')

      exec_home_non_blocking("rvmsudo passenger stop -p#{ports[0]}")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby dealomio_reporting_api.rb stop -p 3001")

      # stoping the daemons
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby scripts/logging.rb stop")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby scripts/report.rb stop")
    end

  end

end
