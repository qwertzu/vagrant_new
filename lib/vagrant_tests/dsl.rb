module VagrantTest

  class VM

    attr_accessor :services, :ip, :name, :vagrant_env, :base_box, :vm

    def initialize name, base_box
      @base_box = base_box
      @name = name
    end

    attr_accessor :dir
    
    def vm
      vagrant_env.vms.each { |vm_name, vm| @vm = vm if vm_name == name } unless @vm
      @vm
    end
    
    def vagrant_env
      @vagrant_env ||=  Vagrant::Environment.new
    end

    def exec(cmd , dir = "/")
      puts "#{vm.name}: Execute #{cmd}"
      begin
        vm.channel.execute("cd #{dir} && " + cmd) do |output,data|
          print "#{data}"
        end
      rescue
        puts 'Caught an EXCEPTION'
      end
    end

    def sudo(cmd)
      puts "#{vm.name}: Sudo #{cmd}"
      begin
        vm.channel.sudo("#{cmd}") do |output,data|
          print "#{data}"
        end
      rescue
        puts 'Caught an EXCEPTION'
      end
    end

    def up
      #unless @vagrant_env.state == :poweroff
      #  puts "VM #{@vagrant_env.name} , #{@vagrant_env.env} already running , halt VM..."
      #  @vagrant_env.halt
      #end

      destroy if vm.state == :running
      unless vm.state == :running
        puts "About to run #{vm.name}:-up..."
        vm.up
        puts "Finished running #{vm.name}:-up"
      end
      puts "Copy config files"
      sudo("cp /vagrant/hosts /etc/hosts")
      sudo("ls /vagrant")
      sudo("cp /vagrant/apache-conf/* /etc/apache2/")
      sudo("cp /vagrant/apache-conf/sites-available/* /etc/apache2/sites-available/")
      sudo("cd /etc/apache2/sites-enabled && a2ensite *")
      puts "enabled apache files"
    end

    def destroy
      puts "destroy VM"
      vm.destroy
      puts "VM destroyed"
    end

    def halt
      raise "Must run `vagrant up`" if !vm.created?
      raise "Must be running!" if vm.state != :running
      puts "About to run #{vm.name}:-halt..."
      vm.halt
      puts "Finished running #{vm.name}:-halt"
    end

    def add service_clazz
      service_clazz.vm = self
      (@services ||= []) << service_clazz
      puts service_clazz.inspect
      service_clazz
    end

  end

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


