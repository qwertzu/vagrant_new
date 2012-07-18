#v.exec('rm -rf reports')

require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Integration < VagrantTest::Service

  class << self

    def init
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')
    end

    def run
      init #TODO remove when init-start-stop funktioniert
     exec_home('cp -v config/application.yml.example config/application.yml')
    end

    def code_directory
      Settings.integration_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end
