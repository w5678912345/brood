class CreateRoleSessions < ActiveRecord::Migration
  def change
    create_table :role_sessions do |t|
      t.integer :role_id
      t.integer :computer_id
      t.integer :start_level
      t.integer :start_gold
      t.integer :start_exp
      t.integer :used_gold
      t.integer :exchanged_gold
      t.string :task
      t.integer :connection_times
      t.datetime :live_at

      t.timestamps
    end
  end
end
