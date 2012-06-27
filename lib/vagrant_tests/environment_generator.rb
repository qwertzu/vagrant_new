TEMPLATE = File.read(File.expand_path(File.dirname(__FILE__) + './../../templates/vagrant.erb'))

module VagrantTest

  class EnvironmentGenerator

    class << self

      def generate(config)
        services   = config.vms.map(&:services).flatten
        free_ips   = get_free_ips(config.vms.size)
        free_ports = get_free_ports(services.map { |service| service.ports.size }.sum)

        config.vms.each do |vm|
          vm.ip = free_ips.shift
          vm.services.each do |service|
            service.ip            = vm.ip
            service.port_forwards = Hash[*service.ports.map { |port| [port, free_ports.shift] }.flatten]
          end
        end

        write_hosts(services)
        write_vagrant_file(config)
      end

      def get_free_ips number
        if (ip_mem = File.open(Settings.ip_mem, 'a+'))
          free_ips    = []
          ip_adress   = 101
          ip_sbmask   = 0
          sbmask_used = true
          lines       = ip_mem.readlines

          while sbmask_used == true

            ip_sbmask   += 1
            sbmask_used = false

            lines.each do |line|
              sbmask_used = true if line.split('.')[2].to_i == ip_sbmask
            end
          end
          while free_ips.length < number
            ip_mem.puts("192.168.#{ip_sbmask}.#{ip_adress}")
            free_ips << "192.168.#{ip_sbmask}.#{ip_adress}"
            ip_adress += 1
          end

          free_ips
        else
          puts 'Memory File not found'
        end

      end


      def get_free_ports (number)
        portnumber = 8100
        ports      = []
        while ports.length < number
          ports << portnumber if is_port_open(portnumber)
          portnumber += 1
        end
        ports
      end


      def is_port_open(port)
        begin
          TCPServer.open(port).close
        rescue
          return false
        end
        return true
      end

      def write_hosts(services)
        puts "create hosts file"
        hosts_file = File.open(Settings.hosts_file, 'w')
        hosts_file.puts("127.0.0.1 localhost vagrant")

        services.each { |service| hosts_file.puts("#{service.ip} #{service.name}") }
        hosts_file.close
      end

      def write_vagrant_file(config)
        puts "create Vagrantfile"
        vag_file = File.open(Settings.vagrant_file, 'w')
        vag_file.write(ERB.new(TEMPLATE).result(binding))
      end


      def delete_ips
        hosts_file = File.open(Settings.hosts_file, 'a+')
        hosts_file.readline #first line = localhost
        sub_net = hosts_file.readline.split('.')[2]
        hosts_file.close
        ip_mem = File.open(Settings.ip_mem, 'a+')
        lines  = ip_mem.readlines
        ip_mem.close
        ip_mem = File.open(Settings.ip_mem, 'w')
        lines.each do |line|
          ip_mem.puts line if line.split('.')[2] != sub_net
        end
        ip_mem.close
      end


    end

  end

end