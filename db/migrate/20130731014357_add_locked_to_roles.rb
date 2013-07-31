class AddLockedToRoles < ActiveRecord::Migration
  def change
  	add_column	:roles,	:locked,			:boolean, :null => false,:default => false
  end
end
