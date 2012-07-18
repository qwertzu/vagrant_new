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
      exit_status=42
      begin
        vm.channel.execute("cd #{dir} && " + cmd) do |output,data|
          print "#{data}"
          if data.match /examples, 0 failure/
            exit_status=0
          elsif  data.match /examples, .* failure/
            exit_status=1
          else
            exit_status=2
          end
        end
      rescue => e
        if cmd.match /rspec/
          #  if tests fail, we become an exception:
          # #<Vagrant::Errors::VagrantError: The following SSH command responded with a non-zero exit status.
          exit_status = 10
        else
          exit_status = 11
          puts 'Caught an EXCEPTION'
         end
      end
      exit_status
    end

    def sudo(cmd)
      puts "#{vm.name}: Sudo #{cmd}"
      exit_state = 0
      begin
        vm.channel.sudo("#{cmd}") do |output,data|
          print "#{data}"
        end
      rescue
        puts 'Caught an EXCEPTION'
      end
      exit_state
    end

    def add service_clazz
      service_clazz.vm = self
      (@services ||= []) << service_clazz
    end

    def state
      vm.state
    end

    def destroy
      puts "destroy VM"
      vm.destroy
      puts "VM destroyed"
    end

    def halt
      raise "Must run `vagrant up`" if !vm.created?
      raise "Must be running!" if vm.state != (:running || :saved)
      puts "About to run #{vm.name}:-halt..."
      vm.halt
      puts "Finished running #{vm.name}:-halt"
    end

    def up
      if vm.state == :running || vm.state == :suspend
        puts "About to stop VM #{vm.name} for reboot..."
        vm.halt
        puts "About to boot VM #{vm.name}..."
        vm.start
      elsif vm.state == :poweroff
        puts "About to boot VM #{vm.name}..."
        vm.start
      else
        puts "About to import VM #{vm.name} for boot (this can take a few minutes)..."
        VagrantTest::Lock.sync { vm.up }
      end

      puts "Finished running #{vm.name}:-up"
      puts "Copy config files"
      sudo("cp /vagrant/#{Settings.hosts_file} /etc/hosts")
      self.services.each do |service|
        service.exec_home("gem install bundler")
        service.exec_home("bundle")
      end
    end

=begin
        def up environment = nil
           if vm.state == :running
        puts "About to stop services of #{vm.name}:-rerun..."
         @services.flatten.each do |service|
          service.rails_env = environment.rails_env
          service.stop
        end
        puts "Finished to stop services of #{vm.name}:-rerun..."
      end
=end
    def reload
      VagrantTest::Lock.sync { vm.reload }
    end

    def method_missing(method, *args, &block)
      self.vm.__send__(method, *args, &block)
    end

  end


end

