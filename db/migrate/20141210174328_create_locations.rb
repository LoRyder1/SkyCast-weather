class CreateLocations < ActiveRecord::Migration
  def change
  	create_table :locations do |t|
  		t.string :city
  		t.string :state
  		t.string :country
  		t.date :date
  		t.float :latitude
  		t.float :longitude
  	end
  end
end
