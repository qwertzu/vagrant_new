require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Management < VagrantTest::Service

  class << self

    def run
      vm.sudo('service mysql start')
      vm.exec('cd /vagrant/management/')
      vm.exec('bundle install')
      vm.exec('cp -v config/application.yml.example config/application.yml')
      vm.exec('cp -v config/database.yml.example config/database.yml')
      vm.exec('cp -v config/newrelic.yml.example config/newrelic.yml')
      vm.exec('RAILS_ENV=vagrant rake db:migrate')
      vm.sudo('/etc/init.d/apache2 start')
    end

    def code_directory
      "~/#{self.name}" # TODO fetch from application.yml
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end
