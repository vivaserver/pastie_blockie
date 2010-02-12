class Revision < ActiveRecord::Base
  validates_presence_of :snippet, :message => "can't be blank"
  belongs_to :block
end
