class AddRoleProfileIdToRoleSessions < ActiveRecord::Migration
  def change
    add_column :role_sessions, :role_profile_id, :integer
    add_index :role_sessions, :role_profile_id
  end
end
