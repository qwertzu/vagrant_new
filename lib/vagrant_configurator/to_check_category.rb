class To_check_category
  # To change this template use File | Settings | File Templates.

  attr_accessor :id, :label, :to_check_Or_category, :status, :father_cat, :deep_cat, :not_checked_category

  def initialize name, father_cat=nil
    @label=name
    @to_check_Or_category = []
    @not_checked_category = []

    if father_cat == nil
      @deep_cat=0
    else
      @deep_cat=father_cat.to_check_Or_category.size+1
    end

    @id = IdFactory.create father_cat

    @status=nil


  end

  # Modify the ID of the object to_be_added
  def add_a_check to_be_added
    @to_check_Or_category << to_be_added
    to_be_added.id.setId @to_check_Or_category.size
  end


  # Modify the ID of the object to_be_added
  def add_a_noncheck to_be_added
    @not_checked_category << to_be_added
    to_be_added.id.setId @not_checked_category.size
  end

  def check
    check_inform(self)
    @to_check_Or_category.each{ |tc|
      tc.check
    }
  end

  def print_non_check
    @not_checked_category.each{ |ntc|
      check_inform(ntc)
    }
  end

end