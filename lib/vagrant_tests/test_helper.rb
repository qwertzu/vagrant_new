class V

	def initialize dir , server_name
		@env = Vagrant::Environment.new
		@env.vms.each do | vm_name , vm|
		  @env = vm if vm_name == server_name
		end
		@dir = dir
	end

  attr_accessor :dir

	def exec(cmd)
		puts "Execute #{cmd}"
		begin
			@env.channel.execute("cd #{@dir} && #{cmd}") do |output,data|
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
end
