require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Imageserver < VagrantTest::Service

  class << self

    def run
      exec_home("gem install bundler")
      exec_home('bundle install')
      exec_home('cp -v config/application.yml.example config/application.yml')
      sudo('/etc/init.d/redis-server start')
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/deal_consumer_daemon run &")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/detail_picture_consumer_daemon run &")
      exec_home_non_blocking("RAILS_ENV=#{rails_env} ruby script/picture_consumer_daemon run &")
      #sudo('/etc/init.d/apache2 start')
      exec_home_non_blocking("RAILS_ENV=#{rails_env} rvmsudo passenger start -p80 -d --user vagrant -e vagrant &")
    end

    def code_directory
      Settings.imageserver_path
    end

    def ports
      [80]
    end

    def stop
      #TODO implement me!
    end

  end

end