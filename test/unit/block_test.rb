require 'test_helper'

class BlockTest < ActiveSupport::TestCase
  
  # passing cookie string as argument for Block.viewable
  test "private blocks viewable for owner" do
    assert_equal Block.viewable('435Ryo5W2R0y65Q5etcMLw==').size, 2
  end
  
  test "private blocks not viewable for non-owners" do
    assert_equal Block.viewable('non_existing_cookie').size, 1
  end

  test "any block always includes one latest revision" do
    assert_kind_of Revision, blocks(:public).latest_revision
  end

end
