class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :class_level
      t.string :child_first_name
      t.string :child_last_name
      t.datetime :child_dob
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :parent_first_name
      t.string :parent_last_name
      t.string :parent_day_phone
      t.string :parent_cell_phone
      t.string :emergency_contact_name
      t.string :emergency_contact_phone
      t.string :authorized_picked_up_by
      t.string :learned_from

      t.timestamps
    end
  end
end
