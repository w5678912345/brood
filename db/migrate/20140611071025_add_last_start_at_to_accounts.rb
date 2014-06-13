class AddLastStartAtToAccounts < ActiveRecord::Migration
  def change
  	add_column  :accounts, :last_start_at, :datetime, :null => true
  end
end
