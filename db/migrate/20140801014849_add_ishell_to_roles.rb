class AddIshellToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :ishell, :boolean, :null=>false, :default => false
  end
end
