class AddAccountRoleSessionRelation < ActiveRecord::Migration
  def change
    add_column :role_sessions,:account_session_id,:integer
    add_index :role_sessions,:account_session_id

    add_column :history_role_sessions, :account_session_id,:integer
    add_index :history_role_sessions,:account_session_id
  end
end
