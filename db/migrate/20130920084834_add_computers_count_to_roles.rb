class AddComputersCountToRoles < ActiveRecord::Migration
  def change
  	add_column  :roles,	:computers_count,				:integer, :null => false,:default => 0
  end
end
