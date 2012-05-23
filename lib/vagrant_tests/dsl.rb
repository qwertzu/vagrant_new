module VagrantTest

  class Service

    class << self

      attr_accessor :ip, :path, :port_forwards, :vm

      def name
        self.to_s.downcase
      end

      def run

      end

      def code_directory
        "~/#{self.name}"
      end

      def ports
        [80]
      end

      def stop

      end

    end

  end

  class EnvironmentConfiguration

    attr_accessor :vms, :spec_path, :test_vm

    def add_vm name, base_box = Settings.base_box
      (@vms ||= []) << (vm = VM.new(name, base_box))
      yield vm if block_given?
      vm
    end

  end

  module DSL

    def vagrant_test
      environment = EnvironmentConfiguration.new
      yield environment

      EnvironmentGenerator.generate(environment)

      environment.vms.each { |vm| vm.up }
      environment.vms.map(&:services).flatten.each { |service| service.run }

      environment.test_vm.exec("bundle exec rspec #{environment.spec_path}")

      environment.vms.each { |vm| vm.halt }
    end

  end

end

#
# vagrant_test do |env|
#    man = env.add_vm(name, base_box)
#    man.add Management
#
#    env.add_vm do |vm|
#      vm.add Targeting
#      vm.add Dealkeeper
#    end
#   env.rspec '../path_to_spec/'
#   env.test_vm man
# end


