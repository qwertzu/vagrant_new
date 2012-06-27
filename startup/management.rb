require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Management < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')
      exec_home('cp -v config/database.yml.example config/database.yml')
      exec_home('cp -v config/newrelic.yml.example config/newrelic.yml')

      # creating the database
      exec_home('mysql -u'+Settings.mysql_username+' -p'+Settings.mysql_password+' -e "create database deal_management_vagrant"')
      exec_home("RAILS_ENV=#{rails_env} rake db:migrate")
      exec_home("mysql -u"+Settings.mysql_username+" -D deal_management_vagrant -p"+Settings.mysql_password+" -e \"insert into users(id, email,  encrypted_password, authentication_token, is_admin, created_at, updated_at) values('12345', 'vagrant@radcarpet.com', '$2a$10$WxaXM1KwJqBQBwqKa80ppOjp8fRjQVs6ZOmy55qXF9fXG.ZfQ3S5y',  'JqqDmevPwzXGeLVgs99p', 1, '2012-06-15 15:09:18', '2012-06-15 15:09:18');\"")
      exec_home("mysql -u"+Settings.mysql_username+" -D deal_management_vagrant -p"+Settings.mysql_password+" -e \"insert into users(id, email,  encrypted_password, authentication_token, is_admin, created_at, updated_at) values('12346', 'sandner@servtag.com', '$2a$10$WxaXM1KwJqBQBwqKa80ppOjp8fRjQVs6ZOmy55qXF9fXG.ZfQ3S5y', 'wpAsxZnzq5BA1jnTDLzm', 0, '2012-06-15 15:09:18', '2012-06-15 15:09:18');\"")

      # starting/stoping services
      sudo('/etc/init.d/redis-server start')
      sudo("service apache2 stop")

     # exec_home_non_blocking('nohup rvmsudo passenger start -p80 -d --user vagrant -e vagrant')
      #exec_home("rvmsudo passenger start -p80 -d --user vagrant -e vagrant")
      #exec_home(" `echo 'rvmsudo passenger start -p80 -d --user vagrant -e vagrant' ` ")
      #exec_home("./start-vagrant2.rb &")

      # starting server
      exec_home("rvmsudo passenger start -p80 -d --user vagrant -e vagrant &> /dev/null")

     # spawn({"RAILS_ENV" => "vagrant"}, exec_home("rvmsudo passenger start -p80 -d --user vagrant -e vagrant"))

      #Net::SSH.start(self.ip, "vagrant", :password => "vagrant1") do |ssh|
      #  output = ssh.exec!("cd /vagrant/targeting/ && rvmsudo passenger start -p80 -d --user vagrant -e vagrant")
      #  ssh.exec!("echo 'test' > log2")
      #end

      #puts "`cd /vagrant/targeting/ && rvmsudo passenger start -p80 -d --user vagrant -e vagrant`"

      #exec_home("sleep 120s")

      #exec_home_non_blocking2("rvmsudo passenger start -p80 -d --user vagrant -e vagrant"))
     # exec_home('RAILS_ENV=vagrant passenger start -p4363 -d') if fork().nil?
    end

    def code_directory
      Settings.management_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end
