class Block < ActiveRecord::Base
  belongs_to :language
  has_many :revisions, :dependent => :destroy, :order => 'created_at desc'
  
  def self.viewable(signature,page=1)
    paginate :conditions => ["is_private = ? or signature = ?", false, signature], 
             :per_page => 5,
             :order => 'created_at desc', 
             :page => page
  end
  
  # used to display only snippet's latest revision on listings
  def latest_revision
    revisions.first
  end
end
