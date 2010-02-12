class Block < ActiveRecord::Base
  has_many :revisions, :dependent => :destroy, :order => 'created_at desc'
  accepts_nested_attributes_for :revisions
  
  def self.viewable(signature)
    find(:all, :conditions => ["is_private = ? or signature = ?", false, signature])
  end
  
  # used to display only snippet's latest revision on listings
  def latest_revision
    revisions.first
  end
  
  # used only to create the first revision for a new snippet
  def revisions_attributes(attributes)
    revisions.create.attributes.first
  end
end
