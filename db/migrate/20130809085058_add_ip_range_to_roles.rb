class AddIpRangeToRoles < ActiveRecord::Migration
  def change
  	add_column	:roles,	:ip_range,			:string, :null => true
  end
end
