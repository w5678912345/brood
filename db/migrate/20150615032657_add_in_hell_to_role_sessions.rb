class AddInHellToRoleSessions < ActiveRecord::Migration
  def change
    add_column :role_sessions, :in_hell, :boolean,default: false
    add_index :role_sessions, :in_hell
  end
end
