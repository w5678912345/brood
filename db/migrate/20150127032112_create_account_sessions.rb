class CreateAccountSessions < ActiveRecord::Migration
  def change
    create_table :account_sessions do |t|
      t.string :account_id
      t.string :computer_name
      t.string :ip ,:limit => 16

      t.string :started_status
      t.datetime :finished_at
      t.boolean :finished
      t.string :finished_status
      t.string :remark

      t.timestamps
    end
    add_index :account_sessions,:account_id
    add_index :account_sessions,:computer_name
    add_index :account_sessions,:started_status
    add_index :account_sessions,:finished_status
    add_index :account_sessions,:created_at
    add_index :account_sessions,:ip
  end
end
