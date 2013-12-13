class AddGroupToComputers < ActiveRecord::Migration
  def change
  	add_column :computers, :group, :string
  end
end
