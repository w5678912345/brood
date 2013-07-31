class AddLostToRoles < ActiveRecord::Migration
  def change
  	add_column	:roles,	:lost,			:boolean, :null => false,:default => false
  end
end
