require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Targeting < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home("bundle install")

      # copying configuration files
      exec_home('cp -v config/redis.yml.example config/redis.yml')
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/logcaster.yml.example config/logcaster.yml')

      # starting/stoping services
      sudo('/etc/init.d/redis-server start')
      sudo('service apache2 stop')

      #exec_home('redis-server &')
      #exec_home_ssh("rvmsudo passenger start -p80 -d --user=vagrant -e vagrant")
      #exec_home("passenger start -p8165 &")
      #exec_home_non_blocking2("rvmsudo passenger start -p81 --user vagrant -e vagrant")
      #exec_home(" `echo 'rvmsudo passenger start -p80 --user vagrant -e vagrant &' ` ")
      #exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby dealomio_targeting.rb -p3000 &")
      #%Q(ssh "vagrant"@"#{self.ip}"  "rvmsudo passenger start -p80 -d --user vagrant -e vagrant")
      #exec_hone("rvmsudo passenger start -p80 -d --user vagrant -e vagrant")
      #Net::SSH.start(self.ip, "vagrant", :password => "vagrant1") do |ssh|
      #  output = ssh.exec!("cd /vagrant/targeting/ && rvmsudo passenger start -p80 -d --user vagrant -e vagrant")
      #end

      # starting the server / service
      exec_home("rvmsudo passenger start -p80 -d --user vagrant -e vagrant &> /dev/null")
      exec_home("RAILS_ENV=#{rails_env} rvmsudo ruby dealomio_targeting.rb -p 3001 &")

      # starting the daemons
      exec_home("RAILS_ENV=#{rails_env} ruby script/targeting_publisher_consumer_daemon start")
      exec_home("RAILS_ENV=#{rails_env} ruby script/targeting_adspace_consumer_daemon start")
    end

    def code_directory
      Settings.targeting_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end
