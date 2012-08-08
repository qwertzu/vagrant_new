TEMPLATE = File.read(File.expand_path(File.dirname(__FILE__) + './../../templates/vagrant.erb'))

module VagrantTest

  class EnvironmentGenerator

    class << self
      def generate(config)
        services = config.vms.map(&:services).flatten
        config.vms.each do |vm|
          get_free_vm(vm)
          puts vm.env.vms.keys
          vm.vm = vm.env.vms["vm#{vm.id}".to_sym]
          vm.ip = "192.168.100.#{vm.id}"

          vm.services.each do |service|
            service.id = vm.id
            service.ip = vm.ip
            unless service.code_directory.eql? ""

              FileUtils.cp_r(File.expand_path(service.code_directory + "/") , "#{Settings.shared_folder}/#{vm.id}/#{service.name}/", :verbose => true)
            end
          end
        end
        write_hosts(services)
      end

      def write_hosts(services)
        puts "create hosts file"
        hosts_file = File.open(Settings.shared_folder + "/hosts", 'w')
        hosts_file.puts("127.0.0.1 localhost vagrant")

        services.each { |service| hosts_file.puts("#{service.ip} #{service.name} vm#{service.id}") }
        hosts_file.close
      end

      def get_free_vm vm
        if (vm_file = File.open(Settings.used_vm_file, 'a+'))
          machine_id  = 2
          free        = true
          lines       = vm_file.readlines

          while machine_id <= Settings.max_vm + 1
            lines.each {|line| free = false if line.to_i == machine_id}
            if free
              vm_file.puts(machine_id.to_s)
              vm_file.close
              vm.id = machine_id
              return machine_id
            end
            if machine_id == Settings.max_vm + 1
              puts "Waiting for free VMs"
              sleep(60)
              machine_id = 1
            end
            machine_id += 1
            free = true
          end
        else
          puts 'VM File not found'
        end
        exit(5)
      end

      def remove_vm_mem vm
        if (vm_file = File.open(Settings.used_vm_file, 'r'))
          new_file  = ""
          lines     = vm_file.readlines
          vm_file.close
          vm_file = File.open(Settings.used_vm_file, 'w+')

          lines.each {|line|puts line + "dd"; puts vm.id.to_s + "d"; new_file << line unless line.eql? (vm.id.to_s + "\n")}
          vm_file.write new_file
          vm_file.close
        else
          puts 'VM File not found'
        end

      end

    end

  end

end