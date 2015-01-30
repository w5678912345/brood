class AddComputerIdToAccountSession < ActiveRecord::Migration
  def change
    add_column :account_sessions, :computer_id, :integer
    add_index :account_sessions, :computer_id

    remove_index :account_sessions, :computer_name
    remove_column :account_sessions, :computer_name

  end
end
