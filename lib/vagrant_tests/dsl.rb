module VagrantTest

  class VM

    attr_accessor :services, :ip, :name, :env, :base_box

    def initialize server_name, base_box
      @base_box = base_box
      @env = Vagrant::Environment.new
      @env.vms.each do | vm_name , vm|
        @env = vm if vm_name == server_name
      end
    end

    attr_accessor :dir

    def exec(cmd)
      puts "Execute #{cmd}"
      begin
        @env.channel.execute(cmd) do |output,data|
          print "#{data}"
        end
      rescue
        puts 'Caught an EXCEPTION'
      end
    end

    def sudo(cmd)
      puts "Sudo #{cmd}"
      begin
        @env.channel.sudo("#{cmd}") do |output,data|
          print "#{data}"
        end
      rescue
        puts 'Caught an EXCEPTION'
      end
    end

    def up
      #unless @env.state == :poweroff
      #  puts "VM #{@env.name} , #{@env.env} already running , halt VM..."
      #  @env.halt
      #end
      destroy if @env.state == :running
      unless @env.state == :running
        puts "About to run vagrant-up..."
        @env.up
        puts "Finished running vagrant-up"
      end
      puts "Copy config files"
      sudo("cp /vagrant/configs/hosts /etc/hosts")
      sudo("cd /etc/apache2/sites-enabled && a2dissite *")
      sudo("rm /etc/apache2/sites-available/05* &&  cp /vagrant/configs/apache_confs/* /etc/apache2/sites-available/")
      sudo("cd /etc/apache2/sites-enabled && a2ensite *")
      puts "enabled apache files"
    end
    def destroy
      @env.destroy
      puts "VM destroyed"
    end

    def halt
      raise "Must run `vagrant up`" if !@env.created?
      raise "Must be running!" if @env.state != :running
      puts "About to run vagrant-halt..."
      @env.halt
      puts "Finished running vagrant-halt"
    end

    def add service_clazz
      service_clazz.vm = self
      (@services ||= []) << service_clazz
    end

  end

  class Service

    class << self

      attr_accessor :ip, :path, :port_fowards, :vm

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

    def add_vm name, base_box = 'servtag-test08'
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


