class CreateHistoryRoleSessions < ActiveRecord::Migration
  def change
    create_table :history_role_sessions do |t|
      t.integer :id
      t.datetime :begin_at
      t.datetime :end_at
      t.integer :gold
      t.integer :exchanged_gold
      t.integer :connection_times
      t.string :ip
      t.string :task
      t.string :result
      t.integer :role_id
      t.integer :account_id
      t.integer :computer_id
      t.string :role_name
      t.string :computer_name
      t.integer :begin_level
      t.integer :end_level
      t.integer :begin_power
      t.integer :end_power
      t.string :account_key
      t.string :server
      t.string :version
      t.string :game_version

      t.timestamps
    end
    add_index :history_role_sessions,:role_id
    add_index :history_role_sessions,:account_id
    add_index :history_role_sessions,:computer_id
  end
end
