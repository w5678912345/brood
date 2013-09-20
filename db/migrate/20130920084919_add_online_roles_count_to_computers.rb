class AddOnlineRolesCountToComputers < ActiveRecord::Migration
  def change
  	add_column  :computers,	:online_roles_count, :integer, :null => false, :default => 0
  end
end
