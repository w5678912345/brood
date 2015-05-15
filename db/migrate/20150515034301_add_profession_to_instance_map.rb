class AddProfessionToInstanceMap < ActiveRecord::Migration
  def change
    add_column :instance_maps, :profession, :string, :default => 'all'
    add_index :instance_maps, :profession
  end
end
