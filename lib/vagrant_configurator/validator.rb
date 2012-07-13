require File.expand_path(File.dirname(__FILE__) + '/vagrant_configurator_helper')
# Validate the check
# Print the result
# Possible improvment: present a solution/do the solution

class Validator
  # To change this template use File | Settings | File Templates.

  attr_accessor :id, :label, :to_check, :expected, :status, :solution, :father_cat, :display_offset # TODO not_expected[]] for solution

  def initialize to_check, expected, label=nil, solution=nil, father_cat=nil
    @to_check=to_check
    @expected = expected
    @label = label
    @solution=solution
    @id = NumerationFactory.create father_cat
    @status= -1

    @father_cat = father_cat
    if father_cat != nil
      @display_offset=father_cat.display_offset+1
    else
      @display_offset=0
    end

  end


  def check
   if @to_check.check == expected
     @status=0
   else
    @status=1 # todo check not_expected
   end

    print_validation_result(self)
  end


end