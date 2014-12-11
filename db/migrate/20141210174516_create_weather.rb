class CreateWeather < ActiveRecord::Migration
  def change
  	create_table :weathers do |t|
  		t.integer :temperature
  		t.float :clouds
  		t.string :icon
  	end
  end
end
