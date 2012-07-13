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