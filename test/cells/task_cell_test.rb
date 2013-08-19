require 'test_helper'

class TaskCellTest < Cell::TestCase
  test "sup" do
    invoke :sup
    assert_select "p"
  end
  

end
