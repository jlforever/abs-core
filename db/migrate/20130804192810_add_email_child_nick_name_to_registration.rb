class AddEmailChildNickNameToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :parent_email, :string
    add_column :registrations, :child_nick_name, :string
    add_column :registrations, :heard_from, :string
  end
end
