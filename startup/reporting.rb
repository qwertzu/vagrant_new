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


      # TODO - http://opikanoba.org/linux/couchdb-centos6
      # TODO verschieben nach script
      #sudo('sed -i -e "s/;port = 5984/port = 5984/g" /etc/couchdb/local.ini')
      #sudo('sed -i -e "s/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/g" /etc/couchdb/local.ini')

      # starting/stoping server services
      sudo('service apache2 stop')
      sudo('/etc/init.d/couchdb start')

      exec_home_non_blocking("rvmsudo passenger start -p80 -d --user vagrant -e vagrant &>/dev/null")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby dealomio_reporting_api.rb start -p 3001")

      # starting the daemons
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby scripts/logging.rb start")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby scripts/report.rb start")

      sudo('service couchdb restart')
    end

    def code_directory
      Settings.reporting_path
    end

    def ports
      [80, 5984]
    end

    def stop
      #TODO implement me!
    end

  end

end
