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