class AddClientCountToComputers < ActiveRecord::Migration
  def change
  	add_column :computers, :client_count, :integer, :null => false, :default => 0
  	add_column :computers, :max_accounts, :integer, :null => false, :default => 0
  	add_column :computers, :max_roles,	  :integer, :null => false, :default => 0
  end
end
