require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Rabbit < VagrantTest::Service

  class << self

    def init
    end

    def run
      sudo('/etc/init.d/rabbitmq-server start')
    end

    def code_directory
      ""
    end

    def ports
      [80, 55672]
    end

    def stop
      sudo("service rabbitmq-server stop")
      #sudo("ps -edf | grep rabbitmq |grep -v grep | tr -s ' '| cut -d' ' -f 2 | xargs -n 1 sudo kill -9")  # hardcore killed shutdown
    end

  end

end