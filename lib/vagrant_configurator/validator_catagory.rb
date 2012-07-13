require File.expand_path(File.dirname(__FILE__) + '/vagrant_configurator_helper')

# A category that contains more check
# Attributes:
# @deep_cat
class ValidatorCatagory
  attr_accessor :id, :label, :to_check_Or_category, :status, :father_cat, :display_offset, :not_checked_category

  @@all_main_categories=[] ## the table represent the root of the categorization tree

  def initialize name, father_cat=nil
    @label=name
    @to_check_Or_category = []
    @not_checked_category = []

    if father_cat == nil
      @display_offset=0
      @@all_main_categories << self
    else
      @display_offset=father_cat.display_offset+1
    end

    @id = NumerationFactory.create father_cat

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
    print_validation_result(self)
    @to_check_Or_category.each{ |tc|
      tc.check
    }
  end

  def print_non_check
    @not_checked_category.each{ |ntc|
      print_validation_result(ntc)
    }
  end

  def self.check_all
    @@all_main_categories.each{ |category|
      category.check

    }
    @@all_main_categories.each{ |category|
      category.print_non_check
    }


  end

end