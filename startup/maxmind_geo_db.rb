require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Maxmind_geo_db < VagrantTest::Service

  class << self

    def init
      # installing dependencies
      #exec_home("gem install bundler")
      #exec_home('bundle install')
    end

    def run
      init #TODO remove when init-start-stop funktioniert

      # copying configuration files
      #exec_home('cp -v config/application.yml.example config/application.yml')
      #exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')
      #exec_home('cp -v config/couchdb.yml.example config/couchdb.yml')

      # starting/stoping services
      #exec_home("daemon -X 'cassandra -f'")
      #exec_home("nodetool -h 127.0.0.1 ring")

      # starting server
      #exec_home_non_blocking("rvmsudo passenger start -p#{ports[0]} -d --user vagrant -e #{rails_env} &>/dev/null")

      # starting the daemons
      #exec_home("RAILS_ENV=#{rails_env} ruby script/analytics_consumer_deamon.rb start")
    end

    def code_directory
      Settings.analytics_path
    end

    def ports
      [80]
    end

    def stop
      #exec_home("ps -edf | grep cassandra | grep -v grep | tr -s ' '| cut -d ' ' -f 2 | xargs -n 1 sudo kill -9")
      #exec_home("ps -edf | grep ring | grep -v grep | tr -s ' '| cut -d ' ' -f 2 | xargs -n 1 sudo kill -9")
      #exec_home_non_blocking("rvmsudo passenger stop -p#{ports[0]}")
      #exec_home("RAILS_ENV=#{rails_env} ruby script/analytics_consumer_deamon.rb stop")
    end

  end

end