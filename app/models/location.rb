class Location < ActiveRecord::Base
	geocoded_by :address

	after_validation :geocode, :if => :address_changed?
	validates_presence_of :latitude, :longitude

	has_many :comments
	has_many :likes
end
