class AddTotalForRoles < ActiveRecord::Migration
  def up
			add_column	:roles,	:total,			:integer, :null => false,	:default => 0
			add_column	:roles,	:total_pay,	:integer,	:null => false,	:default => 0	
  end

  def down
			remove_column :roles, :total
			remove_column	:roles,	:total_pay
  end
end
