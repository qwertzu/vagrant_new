require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Analytics < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home("bundle install")

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')
      exec_home('cp -v config/couchdb.yml.example config/couchdb.yml')

      # starting/stoping services
      sudo('service apache2 stop')
      exec_home("daemon -X 'cassandra -f'")
      exec_home("nodetool -h 127.0.0.1 ring")

      # starting server
      exec_home_non_blocking("rvmsudo passenger start -p80 -d --user vagrant -e vagrant &>/dev/null")

      # starting the daemons
      exec_home("RAILS_ENV=#{rails_env} ruby script/analytics_consumer_deamon.rb start")
    end

    def code_directory
      Settings.analytics_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end