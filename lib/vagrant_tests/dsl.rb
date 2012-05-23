module VagrantTest

  class Service

    class << self

      attr_accessor :ip, :path, :port_forwards, :vm, :rails_env

      def name
        self.to_s.downcase
      end

      def run

      end

      def sudo cmd
        vm.sudo (cmd)
      end

      def exec cmd
        vm.exec (cmd)
      end

      def exec_home cmd
        vm.exec(cmd , "/vagrant/" + self.name)
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

    attr_accessor :vms, :spec_path, :test_service  , :rails_env , :ci_rep

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
      @ci_rep = ""
      @ci_rep = "CI_REPORTS=#{ENV['CI_REPORTS']}"  if ENV['CI_REPORTS']
      @ci_rep
    end

  end

  module DSL
    def vagrant_test
      environment = EnvironmentConfiguration.new
      yield environment

      EnvironmentGenerator.generate(environment)
      environment.vms.each { |vm| vm.up}
      environment.vms.map(&:services).flatten.each do |service|
        service.rails_env = environment.rails_env
        service.run
      end

      environment.test_service.exec_home("RAILS_ENV=#{environment.rails_env} #{environment.ci_rep} bundle exec rspec #{environment.spec_path}") unless environment.test_service == nil

      environment.vms.each { |vm| vm.destroy }
      EnvironmentGenerator.delete_ips
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


