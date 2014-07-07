class AddIsHelperToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :is_helper, :boolean,:null=>false,:default => false
  	add_column :roles, :channel_index, :integer, :null=> false, :default => -1
  end
end
