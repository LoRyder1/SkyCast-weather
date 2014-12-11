class Location < ActiveRecord::Base
  # Remember to create a migration!
  has_many :weathers
  belongs_to :user
end
