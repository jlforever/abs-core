class AddStatusToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :status, :text, null: false, index: true, default: 'registered'
  end
end
