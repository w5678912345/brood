class AddUnlockPhoneIdToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :unlock_phone_id, :string, :null => true, :limit => 16
  	add_column :accounts, :unlocked_at,    :datetime, :null => true
  end
end
