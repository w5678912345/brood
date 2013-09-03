class AddIpRange2ToRoles < ActiveRecord::Migration
  def change
  	add_column  :roles,	:name,				:string, :null => true
  	add_column	:roles,	:ip_range2,			:string, :null => true
  end
end
