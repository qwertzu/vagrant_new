Dir[File.join(File.dirname(__FILE__), '*.rb')].each do |f|
  require f
end

# Print the result of a validation in the console
def print_validation_result to_inform
  fullfiller = ""
  offset_unit= "  "
  fullfiller_size=  TermInfo.screen_size[1]-to_inform.label.size-offset_unit.size*to_inform.display_offset-20
  offset=""

  # OK / failed?
  if to_inform.status == nil
    status_info=""
  elsif to_inform.status == 0
    status_info="OK".green
    fullfiller_size = fullfiller_size-6
  else
    status_info="FAILED".red
    fullfiller_size =  fullfiller_size-10
  end

  # left-align according to numerotation size
  fullfiller_size = fullfiller_size - to_inform.display_offset*2

  # if more than 10 items
  if to_inform.id.id >= 10
    fullfiller_size = fullfiller_size -1
  end

  for i in 1 .. fullfiller_size
    fullfiller = fullfiller +"."
  end

  for i in 1 .. to_inform.display_offset
    offset= offset_unit + offset
  end

  if to_inform.class == ValidatorCatagory
    puts offset+to_inform.id.to_s+" "+to_inform.label+"  "+fullfiller
    return 0
  end

  if to_inform.status == 0
    puts offset+to_inform.id.to_s+" "+to_inform.label+"  "+fullfiller+"  ["+status_info+"]"
  else
    $stderr.puts offset+to_inform.id.to_s+" "+to_inform.label+"  "+fullfiller+"  ["+status_info+"]"
  end
end


# Numeration of the displayed menu according to the DIN 1421
class Numeration
  attr_accessor :id

    @@id = 0
    @id= 1
    @father
  def initialize father
    @father = father
  end

  def setId neo_id
    @id = neo_id
  end

    def Numeration.id_generator
      @@id = @@id+1
    end

  def to_s
     if @father == nil
       @id.to_s+"."
     else
       @father.id.to_s+@id.to_s+"."
     end
  end
end

# Creating an ID for the menu
class NumerationFactory
  def self.create father_cat = nil
    res = Numeration.new father_cat
    if father_cat == nil
      res.id  = Numeration.id_generator
    else
      #actually useless because it would be overriden, when added to the category
    end
    res
  end

end