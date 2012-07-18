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
        exit_status = vm.exec(cmd , "/vagrant/" + self.name)
        exit_status
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
    include Process

    # Performs the tests
    def vagrant_test
      # create the environment and the VMs
      environment = EnvironmentConfiguration.new
      yield environment

      EnvironmentGenerator.generate(environment)

      processes = []
      environment.vms.each { |vm| processes << Process.fork{vm.up}}
      processes.each {|process| Process.waitpid(process)}

      environment.vms.map(&:services).flatten.each do |service|
        service.rails_env = environment.rails_env
        service.run
      end

      # Perform the tests for each path
      # First set some variable, to make the bash executed command different according to the test
      exit_state = 0
      environment.spec_path.each do |spec|
        env_variables= "RAILS_ENV=#{environment.rails_env} #{'CI_REPORTS=' << environment.ci_rep unless environment.ci_rep.eql? " "}"
        before_command=""
        after_command=""
        options = "--color #{'--format '<< environment.format unless environment.format.eql? ' '}" #TODO-test
        if spec =~ /frontend/
          before_command="xvfb-run"
        end

        exit_state = environment.test_service.exec_home("#{env_variables} #{before_command} bundle exec rspec #{spec} #{options} #{after_command}") unless environment.test_service == nil
        environment.vms.each { |vm| vm.halt}
        return exit_state
      end

    end

    def dealkeeper_up

    end

  end

end
