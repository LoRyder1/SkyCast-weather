class Weather < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :location
end
