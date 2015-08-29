class AddHoursToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :hours_open, :string
  end
end
