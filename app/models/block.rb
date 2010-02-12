class Block < ActiveRecord::Base
  validates_presence_of :snippet, :message => "can't be blank"
  
  def self.viewable(signature)
    find(:all, :conditions => ["is_private = ? or signature = ?", false, signature])
  end
end
