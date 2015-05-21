class AddBagValueToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :bag_value, :integer
  end
end
