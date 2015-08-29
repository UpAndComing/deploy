class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  validates_presence_of :location_id, :user_id
end
