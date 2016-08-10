class AddGroupToInstanceMap < ActiveRecord::Migration
  def change
    add_column :instance_maps, :group, :string
  end
end
