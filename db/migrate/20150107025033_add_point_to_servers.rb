class AddPointToServers < ActiveRecord::Migration
  def change
  	add_column :servers, :point, :integer, :null => false, :default => 0
  end
end
