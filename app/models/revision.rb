class Revision < ActiveRecord::Base
  validates_presence_of :snippet, :message => "can't be blank"
  belongs_to :block

protected

  # deleting last block's snippet revision also deletes the block itself
  def after_destroy
    self.block.destroy if self.block.revisions.empty? 
  end

end
