

class To_check
  # To change this template use File | Settings | File Templates.

  attr_accessor :id, :label, :to_check, :expected, :status, :solution, :father_cat, :deep_cat # TODO not_expected[]] for solution

  def initialize to_check, expected, label=nil, solution=nil, father_cat=nil
    @to_check=to_check
    @expected = expected
    @label = label
    @solution=solution
    @id = IdFactory.create father_cat
    @status= -1

    @father_cat = father_cat
    if father_cat != nil
      @deep_cat=father_cat.deep_cat+1
    else
      @deep_cat=0
    end

  end


  def check
   if @to_check.check == 0
     @status=0
   else
    @status=1 # todo check not_expected
   end

    check_inform(self) # todo to write

    # faire to_check
    # compare with expected
      # if it the same:
        # status=0
        # print result
       # else # not the expected result
        # can we do something?
       #
  end


end