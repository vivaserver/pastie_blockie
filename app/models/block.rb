class Block < ActiveRecord::Base
  validates_presence_of :snippet, :message => "can't be blank"
end
