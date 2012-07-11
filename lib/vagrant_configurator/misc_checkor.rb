class Box_checkor

  # To change this template use File | Settings | File Templates.
  #attr_reader :directory

  def initialize name = nil
    @name = name
  end

  def check
    #puts  "\n\n\n\n\n"
    #puts %x[vagrant box list |grep #{@name}]
    #puts  "\n\n\n\n\n"
    if %x[vagrant box list |grep #{@name}] =~ /^#{@name}$/
      0
    else
      1
    end
  end
end