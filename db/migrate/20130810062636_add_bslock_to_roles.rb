class AddBslockToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :normal,			:boolean, :null => false,:default => true
  	add_column :roles, :bslocked,		:boolean, :null => false,:default => false
  	add_column :roles, :unbslock_result,:boolean, :null => true
  end
end
