class AddPhoneIdToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts,:phone_id,:string
  end
end
