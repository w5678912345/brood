class AddGiftBagToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :gift_bag, :string
  end
end
