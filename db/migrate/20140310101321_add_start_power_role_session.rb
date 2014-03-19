class AddStartPowerRoleSession < ActiveRecord::Migration
  def up
  	add_column :role_sessions,:start_power,:integer
  end

  def down
  	remove_column :role_sessions,:start_power
  end
end
