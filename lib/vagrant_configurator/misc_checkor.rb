class Box_checkor

  # To change this template use File | Settings | File Templates.
  #attr_reader :directory

  def initialize name = nil
    @name = name
  end

  def check
    if %x[vagrant box list |grep #{@name}] =~ /^#{@name}$/
      true
    else
      false
    end
  end
end