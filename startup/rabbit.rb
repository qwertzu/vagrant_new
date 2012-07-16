require File.expand_path(File.dirname(__FILE__) + '/../lib/vagrant_tests')

class Rabbit < VagrantTest::Service

  class << self

    def init
    end

    def run
      sudo('/etc/init.d/rabbitmq-server stop')
      sudo('/etc/init.d/rabbitmq-server start')
    end

    def code_directory
      ""
    end

    def ports
      [80, 55672]
    end

    def stop
      #TODO implement me!
     #sudo('/etc/init.d/rabbitmq-server stop') stuck the destruction?
    end

  end

end


