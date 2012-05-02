
TEMPLATE = File.read '/var/lib/jenkins/ConfigFileGenerator/vagrant.erb'

def eval_template(exception, env)
  ERB.new(TEMPLATE).result(binding)
end
vag_file = File.open("./Vagrantfile" , 'w')
vag_file.write(eval_template(Exception.new("foo"), nil))



