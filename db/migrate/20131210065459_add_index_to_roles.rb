class AddIndexToRoles < ActiveRecord::Migration
  def change
  	add_index :roles, :account
  end
end
