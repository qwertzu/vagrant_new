def get_free_ips number
	if ip_mem = File.open("/var/lib/jenkins/ConfigFileGenerator/ip_mem", 'r+')
        	free_ips = []
        	ip_adress = 100
		ip_sbmask = 0
		sbmask_used = true
		lines = ip_mem.readlines

		while sbmask_used == true
		
			ip_sbmask += 1
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
	#write_vagrantfile(free_ips , ports)
	free_ips
	else
		puts 'Memory File not found' 
	end
	
end


def get_free_ports (number)
	portnumber = 8100
	ports = []	
	while ports.length < number
		if is_port_open(portnumber)
			ports << portnumber
		end
		portnumber += 1
	end
	ports 
end



def is_port_open(port , ip = "127.0.0.1")
  begin
    TCPSocket.new(ip, port)
  rescue Errno::ECONNREFUSED
    return false
  end
  return true
end


def write_hosts(free_ips)
	hosts_file = File.open("./configs/hosts", 'w')
	hosts_file.puts("127.0.0.1 localhost")
	hosts_file.puts("#{free_ips[0]} management")
	hosts_file.puts("#{free_ips[1]} targeting")
	hosts_file.puts("#{free_ips[1]} dealkeeper")
	hosts_file.puts("#{free_ips[2]} rabbit")
	hosts_file.puts("#{free_ips[3]} analytics")
	hosts_file.puts("#{free_ips[4]} bannerserver")
	hosts_file.puts("#{free_ips[5]} imageserver")
	hosts_file.puts("#{free_ips[6]} integration")
	hosts_file.close
end

def delete_ips
	hosts_file = File.open("./configs/hosts", 'r+')
	hosts_file.read_line #first line = localhost
	sub_net = hosts_file.read_line.split('.')[2]
	hosts_file.close
	ip_mem = File.open("/var/lib/jenkins/ConfigFileGenerator/ip_mem", 'r+')
	lines = ip_mem.readlines
	ip_mem.close
        ip_mem = File.open("/var/lib/jenkins/ConfigFileGenerator/ip_mem", 'w')
	lines.each do |line|
		ip_mem.puts line if line.split('.')[2] != sub_net
	end
	ip_mem.close
 end



			
		 
		
