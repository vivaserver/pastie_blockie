require 'test_helper'

class RevisionTest < ActiveSupport::TestCase

  test "deleting last revision also deletes related block" do
    revision = revisions(:public_rev)
    revision.destroy
    assert revision.block.destroyed?
  end

end
