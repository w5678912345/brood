class AddColumnsToServers < ActiveRecord::Migration
  def change
  	add_column :servers, :goods,		:string, :null => true
  	add_column :servers, :price,		:integer, :null => false, :default => 1
  end
end
