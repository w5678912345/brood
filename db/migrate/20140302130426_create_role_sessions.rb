class CreateRoleSessions < ActiveRecord::Migration
  def change
    create_table :role_sessions do |t|
      t.integer :role_id
      t.integer :computer_id
      t.integer :start_level
      t.integer :start_gold
      t.integer :start_exp
      t.integer :used_gold,:default => 0
      t.integer :exchanged_gold,:default => 0
      t.string :task
      t.integer :connection_times,:default => 0
      t.datetime :live_at

      t.timestamps
    end
    add_index :role_sessions, :role_id
  end
end
