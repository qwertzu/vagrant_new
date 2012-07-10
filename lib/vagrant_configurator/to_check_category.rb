class To_check_category
  # To change this template use File | Settings | File Templates.

  attr_accessor :id, :label, :to_check_Or_category, :status, :father_cat, :deep_cat

  def initialize name, father_cat=nil
    @label=name
    @to_check_Or_category = []

    @id = IdFactory.create father_cat

    @status=nil
    @deep_cat=0
  end

  # Modify the ID of the object to_be_added
  def add_a_check to_be_added
    @to_check_Or_category = @to_check_Or_category + [to_be_added]
    to_be_added.id.setId @to_check_Or_category.size
  end

  def check
    check_inform(self)
    @to_check_Or_category.each{ |tc|
      tc.check
    }
  end

end