class CreateWeather < ActiveRecord::Migration
  def change
  	create_table :weathers do |t|
  		t.date :date
  		t.integer :temperature
  		t.float :clouds
  		t.string :icon
  	end
  end
end
