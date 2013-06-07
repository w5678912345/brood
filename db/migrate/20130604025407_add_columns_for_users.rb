# encoding: utf-8
class AddColumnsForUsers < ActiveRecord::Migration
  def up
  	 add_column :users, :name, :string, :null => true
  	 add_column :users, :is_admin, :boolean, :null => false,:default => false
  end

  def down
  	rename_column :users, :column => :name
  	rename_column :users, :column => :is_admin
  end
end
