class AddColumnsForRoles < ActiveRecord::Migration
  def up
  	add_column :roles, :close, :boolean, :null => true,:default => false
    add_column :roles, :close_hours, :integer, :null => true
  	add_column :roles, :closed_at,:datetime, :null => true
  	add_column :roles, :reopen_at,:datetime, :null => true
  end

  def down
  	remove_column :roles, :close
    remove_column :rolee, :close_hours
  	remove_column :roles, :closed_at
  	remove_column :roles, :reopen_at
  end
end
