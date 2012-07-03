require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Feedback < VagrantTest::Service

  class << self

    def run
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')

      # creating the database
      exec_home('mysql -u'+Settings.mysql_username+' -p'+Settings.mysql_password+' -e "create database dealomio_feedback_api_vagrant"')
      exec_home("RAILS_ENV=#{rails_env} rake db:migrate")     #TODO CHECK


      # starting server
      #exec_home_non_blocking("RACK_ENV=vagrant rvmsudo rackup -p 80 --user vagrant -e vagrant")            # TODO neue / port

      # rackup -p 3003
      sudo("service apache2 stop")

      exec_home('RACK_ENV=vagrant rackup -p 3003')

      #exec_home_non_blocking("RAILS_ENV=#{rails_env} rvmsudo passenger -p 80  -d --user vagrant -e vagrant &> /dev/null")


    end

    def code_directory
      Settings.feedback_path
    end

    def ports
      [80, 3003]
    end

    def stop
      #TODO implement me!
    end

  end

end