def check_inform to_inform
  fullfiller = ""
  offset_unit= "  "
  fullfiller_size=  TermInfo.screen_size[1]-to_inform.label.size-offset_unit.size*to_inform.deep_cat-20
  offset=""

  if to_inform.status == nil
    status_info=""
  elsif to_inform.status == 0
    status_info="OK".green
    fullfiller_size = fullfiller_size-6
  else
    status_info="FAILED".red
    fullfiller_size =  fullfiller_size-10
  end

  for i in 1 .. fullfiller_size
    fullfiller = fullfiller +"."
  end

  for i in 1 .. to_inform.deep_cat
    offset= offset_unit + offset
  end


  if to_inform.class == To_check_category
    puts offset+to_inform.id.to_s+" "+to_inform.label+"  "+fullfiller
    return 0
  end

  if to_inform.status == 0
    puts offset+to_inform.id.to_s+" "+to_inform.label+"  "+fullfiller+"  ["+status_info+"]"
  else
    $stderr.puts offset+to_inform.id.to_s+" "+to_inform.label+"  "+fullfiller+"  ["+status_info+"]"
    #TODO write solution
  end
end


class IdFactory
  def self.create father_cat = nil
    res = Id.new father_cat
    if father_cat == nil
      res.id  = Id.id_generator
    else
      #res.id  = father_cat.to_check_Or_category.size+1 TODO actually useless
    end
    res
  end

end

# Create an ID and present it according to the DIN 1421
class Id
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

    def Id.id_generator
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