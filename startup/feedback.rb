require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Feedback < VagrantTest::Service

  class << self

    def init
      # installing dependencies
      exec_home("gem install bundler")
      exec_home('bundle install')

      sudo("service mysql start")
      exec_home('mysql -u'+Settings.mysql_username+' -p'+Settings.mysql_password+' -e "create database dealomio_feedback_api_vagrant"')
      sudo("service mysql stop")
    end

    def run
      init #TODO remove when init-start-stop funktioniert

      # copying configuration files
      exec_home('cp -v config/application.yml.example config/application.yml')

      # updating database
      sudo("service mysql start")
      exec_home("RAILS_ENV=#{rails_env} rake db:migrate")     #TODO CHECK

      # starting server
      exec_home("RACK_ENV=#{rails_env} rackup -p #{ports[1]} -D")
    end

    def code_directory
      Settings.feedback_path
    end

    def ports
      [80, 3003]
    end

    def stop
      sudo("service mysql stop")
      sudo("ps -ef |grep rackup |grep -v grep | tr -s ' '| cut -d' ' -f 2 | xargs -n 1 sudo kill -9")
    end

  end

end