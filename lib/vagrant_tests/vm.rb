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

    attr_accessor :name, :env, :base_box, :vm, :services, :ip

    def initialize name, base_box
      @base_box = base_box
      @env     = Vagrant::Environment.new
      @name    = name
      @vm      = @env.vms[name]
    end

    def exec(cmd)
      puts "Execute #{cmd}"
      vm.channel.execute(cmd) do |output,data|
        print "#{data}"
      end
    end

    def sudo(cmd)
      puts "Sudo #{cmd}"
      vm.channel.sudo("#{cmd}") do |output,data|
        print "#{data}"
      end
    end

    def add service_clazz
      service_clazz.vm = self
      (@services ||= []) << service_clazz
    end

    def destroy
      vm.destroy
      puts "VM destroyed"
    end

    def halt
      raise "Must run `vagrant up`" if !vm.created?
      raise "Must be running!" if vm.state != :running
      puts "About to run vagrant-halt..."
      vm.halt
      puts "Finished running vagrant-halt"
    end

    def up
      destroy if vm.state == :running
      unless vm.state == :running
        puts "About to run vagrant-up..."
        VagrantTest::Lock.sync { vm.up }
        puts "Finished running vagrant-up"
      end
      puts "Copy config files"
      sudo("cp /vagrant/configs/hosts /etc/hosts")
      sudo("cd /etc/apache2/sites-enabled && a2dissite *")
      sudo("rm /etc/apache2/sites-available/05* &&  cp /vagrant/configs/apache_confs/* /etc/apache2/sites-available/")
      sudo("cd /etc/apache2/sites-enabled && a2ensite *")
      puts "enabled apache files"
    end

    def reload
      VagrantTest::Lock.sync { vm.reload }
    end

    def method_missing(method, *args, &block)
      self.vm.__send__(method, *args, &block)
    end

  end


end

