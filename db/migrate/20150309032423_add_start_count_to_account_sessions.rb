class AddStartCountToAccountSessions < ActiveRecord::Migration
  def change
    add_column :account_sessions, :start_count, :integer,default: 0
    add_index :account_sessions, :start_count
  end
end
