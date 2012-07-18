require File.expand_path(File.dirname(__FILE__) + '/vagrant_configurator_helper')

# Check if the vagrant box exists?
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

# check if a directory exists?
class Directory_checkor

  # To change this template use File | Settings | File Templates.
  attr_reader :directory

  def initialize dir = nil
    @directory = dir
  end

  def check
    if File.directory? @directory
      true
    else
      false
    end
  end
end

# check if a File exists?
class File_checkor

  # To change this template use File | Settings | File Templates.

  def initialize file = nil
    @file = file
  end

  def check
    if File.exist? @file
      true
    else
      false
    end
  end
end

# This represents a setting that is not supported
class UnsupportedSettingCheckor


  attr_reader :directory

  def check
    0
  end

end

# check if 2 variables are the same
# usefull for username, password and URL validation
class Password_checkor

  attr_reader :directory

  def initialize password1, password2
    @password1 = password1
    @password2 = password2
  end

  def check
    if @password1 == @password2
      true
    else
      false
    end
  end
end