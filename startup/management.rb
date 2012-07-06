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
      sudo('service mysql start')
      exec_home('mysql -u'+Settings.mysql_username+' -p'+Settings.mysql_password+' -e "create database deal_management_vagrant"')
      exec_home("RAILS_ENV=#{rails_env} rake db:migrate")
      exec_home("mysql -u"+Settings.mysql_username+" -D deal_management_vagrant -p"+Settings.mysql_password+" -e \"insert into users(id, email,  encrypted_password, authentication_token, is_admin, created_at, updated_at) values('12345', 'vagrant@servtag.com', '$2a$10$k/FYPeqDz1CAzGepLOY6neXVUPowfThBEBt5cDxPbBCZVMKmGmRY2', 'JqqDmevPwzXGeLVgs99p', 1, '2012-06-15 15:09:18', '2012-06-15 15:09:18');\"")
      exec_home("mysql -u"+Settings.mysql_username+" -D deal_management_vagrant -p"+Settings.mysql_password+" -e \"insert into users(id, email,  encrypted_password, authentication_token, is_admin, created_at, updated_at) values('12346', 'sandner@servtag.com', '$2a$10$WxaXM1KwJqBQBwqKa80ppOjp8fRjQVs6ZOmy55qXF9fXG.ZfQ3S5y', 'wpAsxZnzq5BA1jnTDLzm', 0, '2012-06-15 15:09:18', '2012-06-15 15:09:18');\"")

      # starting/stoping services
      sudo('/etc/init.d/redis-server start')
      sudo("service apache2 stop")
      # starting server
      exec_home("rvmsudo passenger start -p80 -d --user vagrant -e vagrant &> /dev/null")
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
