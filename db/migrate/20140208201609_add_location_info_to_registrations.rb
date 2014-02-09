class AddLocationInfoToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :location, :string 
  end
end
