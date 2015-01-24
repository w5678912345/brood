class AddNameIndexToRoleProfiles < ActiveRecord::Migration
  def change
    add_index :role_profiles, :name , :unique => true
  end
end
