module VagrantTest

  class Service

    class << self

      attr_accessor :ip, :path, :port_forwards, :vm, :rails_env

      def name
        self.to_s.underscore
      end

      def run

      end

      def sudo cmd
        vm.sudo(cmd)
      end

      def exec cmd
        vm.exec(cmd)
      end

      def exec_home cmd
        vm.exec(cmd , "/vagrant/" + self.name)
      end

      # TODO  - sich versichern, dass die ouput auf dem Console geschrieben wird
      def exec_home_non_blocking cmd
        vm.exec(cmd, "/vagrant/" + self.name)
      end

      def code_directory
        "~/#{self.name}"
      end

      def ports
        [80]
      end

      def stop
        #TODO implement me
      end

    end

  end

  class EnvironmentConfiguration

    attr_accessor :vms, :spec_path, :test_service, :rails_env , :ci_rep , :format

    def add_vm name, base_box = Settings.base_box
      (@vms ||= []) << (vm = VM.new(name, base_box))
      yield vm if block_given?
      vm
    end
    def rails_env
      @rails_env = "test" unless @rails_env
      @rails_env
    end

    def ci_rep
      @ci_rep = " " unless @ci_rep
      @ci_rep
    end
    def format
      @format = " " unless @format
      @format
    end

  end

  module DSL
    def vagrant_test
      environment = EnvironmentConfiguration.new
      yield environment

      EnvironmentGenerator.generate(environment)
      environment.vms.each { |vm| vm.up}
      environment.vms.map(&:services).flatten.each do |service|
        #Process.fork {
          service.rails_env = environment.rails_env
          service.run
        #}
      end

      #Process.waitall
      environment.spec_path.each do |spec|
        environment.test_service.exec_home("RAILS_ENV=#{environment.rails_env} #{'CI_REPORTS=' << environment.ci_rep unless environment.ci_rep.eql? " "} bundle exec rspec #{spec} --color #{'--format '<< environment.format unless environment.format.eql? " "}") unless environment.test_service == nil
      end
      #environment.vms.each { |vm| vm.destroy }
      #EnvironmentGenerator.delete_ips
      environment.vms.each { |vm| vm.halt}
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


