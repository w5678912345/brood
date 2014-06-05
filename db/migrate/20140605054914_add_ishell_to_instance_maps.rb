class AddIshellToInstanceMaps < ActiveRecord::Migration
  def change
  	add_column :instance_maps, :ishell, :boolean , :null => false, :default => false
  end
end
