
#v.exec('rm -rf reports')




require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Integration < VagrantTest::Service

  class << self

    def run
      exec_home("gem install bundler")
      exec_home('bundle install')
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