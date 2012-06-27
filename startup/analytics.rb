require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Analytics < VagrantTest::Service

  class << self

    def run
      exec_home("gem install bundler")
      exec_home("bundle install")
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')
      exec_home('cp -v config/couchdb.yml.example config/couchdb.yml')
      sudo('service couchdb start')
      sudo('service cashandra start')
      exec_home("RAILS_ENV=#{rails_env} ruby script/analytics_consumer_deamon start")
      exec_home("RAILS_ENV=#{rails_env} ruby script/import_consumer_deamon start")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} rvmsudo passenger start -p80 -d --user vagrant -e vagrant &")
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