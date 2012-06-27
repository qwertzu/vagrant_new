require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Reporting < VagrantTest::Service

  class << self

    def run
      exec_home("gem install bundler")
      exec_home("bundle install")
      exec_home('cp -v config/couchdb.yml.example config/couchdb.yml')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')
      sudo('/etc/init.d/couchdb start')
    #  sudo('/etc/init.d/apache2 start')
      exec_home_non_blocking("rvmsudo passenger start -p80 -d --user vagrant -e vagrant")
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
