class AddMoreColumnsToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :second_child_first_name, :string
    add_column :registrations, :second_child_last_name, :string
    add_column :registrations, :second_child_dob, :string
    add_column :registrations, :second_child_nickname, :string
  end
end
