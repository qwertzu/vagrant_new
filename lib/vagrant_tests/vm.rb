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
      begin
        vm.channel.execute("cd #{dir} && " + cmd) do |output,data|
          print "#{data}"
          message = data
        end
      rescue
        puts 'Caught an EXCEPTION'
        message = nil
      end
      message
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

    def up
      destroy if vm.state == :running
      unless vm.state == :running
        puts "About to run #{vm.name}:-up..."
        VagrantTest::Lock.sync { vm.up }
        puts "Finished running #{vm.name}:-up"
      end
      puts "Copy config files"
      sudo("cp /vagrant/#{Settings.hosts_file} /etc/hosts")
      sudo("cd /etc/apache2/sites-enabled && a2dissite *")
      sudo("cd /etc/apache2/sites-enabled && a2enmod rewrite")
      self.services.each do |service|
        sudo("cp /vagrant/apache-conf/sites-available/#{service.name}.conf /etc/apache2/sites-available/.")
        sudo("cd /etc/apache2/sites-enabled && a2ensite #{service.name}.conf")
        service.exec_home("gem install bundler")
        service.exec_home("bundle")

        begin
          ruby_version = service.exec_home('rvm current').chomp
          passenger_version = service.exec_home('bundle show | grep passenger').match('\d+.\d+.\d+')[0]
          puts passenger_version
          raise() if !passenger_version
          service.exec_home('passenger-install-apache2-module --auto')
          sudo("ln -f -s /usr/local/rvm/gems/#{ruby_version}/gems/passenger-#{passenger_version}/ext/apache2/mod_passenger.so /etc/apache2/symlink_passenger/passenger_modules")
          sudo("ln -f -s /usr/local/rvm/gems/#{ruby_version}/gems/passenger-#{passenger_version} /etc/apache2/symlink_passenger/passenger_root")
          sudo("ln -f -s /usr/local/rvm/wrappers/#{ruby_version}/ruby /etc/apache2/symlink_passenger/passenger_ruby")
          puts("#{service.name} runs with local gemset passenger")
        rescue
          puts("#{service.name} runs with global passenger")
        end
      end
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
