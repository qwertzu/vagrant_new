require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Reporting < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home("bundle install")
      sudo('apt-get install -y couchdb libcouchdb-glib-1.0-2 python-couchdb gir1.2-couchdb-1.0 couchdb-bin --force-yes')

      # copying configuration files
      exec_home('cp -v config/couchdb.yml.example config/couchdb.yml')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')


      # TODO - http://opikanoba.org/linux/couchdb-centos6
      # TODO verschieben nach script
      sudo('sed -i -e "s/;port = 5984/port = 5984/g" /etc/couchdb/local.ini')
      sudo('sed -i -e "s/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/g" /etc/couchdb/local.ini')

      # starting/stoping server services
      sudo('service apache2 stop')
      sudo("ps -edf | grep couch | tr -s ' '| cut -d' ' -f 2 | xargs -n 1 sudo kill -9")   # kill the process that is busying the port :5984 / was at the end
      sudo('service couchdb start') # was at the end 2

      exec_home_non_blocking("rvmsudo passenger start -p80 -d --user vagrant -e vagrant &>/dev/null")
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
      #TODO implement me!
    end

  end

end
