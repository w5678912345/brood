class CreateRoleProfiles < ActiveRecord::Migration
  def change
    create_table :role_profiles do |t|
      t.string :name
      t.text :data,:default => ''
      t.integer :roles_count,:default => 0
      t.integer :version,:default => 1

      t.timestamps
    end
    RoleProfile.create :name => 'Default'
  end
end
