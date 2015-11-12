class AddClientManualToInstanceMaps < ActiveRecord::Migration
  def change
    add_column :instance_maps, :client_manual, :boolean,:default => false
    add_index :instance_maps,:client_manual
  end
end
