class Directory_checkor

  # To change this template use File | Settings | File Templates.
  attr_reader :directory

  def initialize dir = nil
    @directory = dir
  end

  def check
    if File.directory? @directory
      0
    else
      1
    end
  end
end