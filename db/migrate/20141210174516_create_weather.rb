class CreateWeather < ActiveRecord::Migration
  def change
  	create_table :weathers do |t|
  		t.integer :location_id
  		t.integer :temperature
  		t.float :clouds
  		t.string :icon

  		t.timestamps
  	end
  end
end
