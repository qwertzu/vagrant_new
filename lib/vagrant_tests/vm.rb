module VagrantTest

  class Lock

    class << self

      def sync
        exception = nil
        result    = nil

        file = File.new(Settings.lock_file, File::CREAT|File::RDWR, 0644)
        file.flock(File::LOCK_EX)

        puts 'locked'

        begin
          result = yield
        rescue => e
          exception = e
        end

        file.truncate 0
        file.flock(File::LOCK_UN)
        file.close

        puts 'released'

        raise(exception) if exception

        result
      end
    end

  end

  class VM

    class << self
      def vagrant_env
        @vagrant_env ||= Vagrant::Environment.new
      end
    end

    attr_accessor :name, :env, :base_box, :vm, :services, :ip

    def initialize name, base_box
      @base_box = base_box
      @name    = name
    end

    def env
      @env ||= self.class.vagrant_env
    end

    def vm
      @vm ||= env.vms[name]
    end

    def exec(cmd, dir = '/')
      puts "#{vm.name}: Execute #{cmd}"
      message = ""
      exit_status2=""
      begin
        exit_status=vm.channel.execute("cd #{dir} && " + cmd) do |output,data|
          exit_status2=output
          print "#{data}"
          message = data
        end
      rescue
        puts 'Caught an EXCEPTION'
        message = nil
      end
      exit_status
    end

    def sudo(cmd)
      puts "#{vm.name}: Sudo #{cmd}"
      message = ""
      begin
        vm.channel.sudo("#{cmd}") do |output,data|
          print "#{data}"
          message = data
        end
      rescue
        puts 'Caught an EXCEPTION'
        message = nil
      end
      message
    end

    def add service_clazz
      service_clazz.vm = self
      (@services ||= []) << service_clazz
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

    def up environment = nil
      if vm.state == :running
        puts "About to stop services of #{vm.name}:-rerun..."
         @services.flatten.each do |service|
          service.rails_env = environment.rails_env
          service.stop
        end
        puts "Finished to stop services of #{vm.name}:-rerun..."
      else
        puts "About to run #{vm.name}:-up..."
        VagrantTest::Lock.sync { vm.up }
        puts "Finished running #{vm.name}:-up"
        puts "Copy config files"
        sudo("cp /vagrant/#{Settings.hosts_file} /etc/hosts")
        self.services.each do |service|
          service.exec_home("gem install bundler")
          service.exec_home("bundle")
        end
      end
    end

    def reload
      VagrantTest::Lock.sync { vm.reload }
    end

    def method_missing(method, *args, &block)
      self.vm.__send__(method, *args, &block)
    end

  end


end

