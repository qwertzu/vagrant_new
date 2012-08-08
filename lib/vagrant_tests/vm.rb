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
        @vagrant_env ||= Vagrant::Environment.new(:cwd => Settings.shared_folder)
      end

    end

    attr_accessor :name, :env, :base_box, :vm, :services, :ip, :id

    def initialize name, base_box
      @base_box = base_box
      @name    = name
    end

    def env
      @env ||= self.class.vagrant_env
    end


    def exec(cmd, dir = '/')
      puts "#{vm.name}: Execute #{cmd} in #{dir}"
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

    def reload
      VagrantTest::Lock.sync { vm.reload }
    end

    def delete_data_stores
      delete_mysql_data
      delete_redis_keys
      FileUtils.rm_r(Dir.glob(File.expand_path(Settings.shared_folder + "/" + self.id.to_s + "/*")))
      sudo("rm -r /vagrant/#{self.id}/*")
      puts "all data deleted"
    end

    def delete_mysql_data
      exec('mysql -uroot -proot  -e "show databases" | grep -v -E "Database|mysql|information_schema" | xargs -I "@@" mysql -uroot -proot -e "DROP database \`@@\`"')
    end

    def delete_redis_keys
      exec("redis-cli flushall")
    end

    def method_missing(method, *args, &block)
      self.vm.__send__(method, *args, &block)
    end

  end


end

