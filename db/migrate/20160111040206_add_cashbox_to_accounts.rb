class AddCashboxToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :cashbox, :integer,:default => 0
  end
end
