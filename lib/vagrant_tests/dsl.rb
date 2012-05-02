module VagrantTest

  module Service

    def path
      '../'
    end

    def run

    end

    def port_forwards
      [80]
    end


    def virtual_machine

    end

    def stop
      self.virtual_machine.halt
    end

  end

  class Environment

    attr_accessor :services, :spec_path, :vm

    def add service
      @services << service
    end

    def rspec path
      @spec_path = path
    end

    def test_vm service
      @vm = service.virtual_machine
    end

  end

  module DSL

    def vagrant_test
      environment = Environment.new
      yield environment

      ConfigGen.generate(environment.services)

      # create symlinks

      environment.services.each do |service|
        service.run
      end

      environment.test_vm.exec("bundle exec rspec #{environment.spec_path}")

      environment.services.each do |service|
        service.stop
      end

    end

  end

end

#
# vagrant_test do |env|
#   env.add Management
#   env.add Targeting
#   env.rspec '../path_to_spec/'
#   env.test_vm Management
# end


