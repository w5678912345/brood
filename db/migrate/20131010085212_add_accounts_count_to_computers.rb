class AddAccountsCountToComputers < ActiveRecord::Migration
  def change
  	add_column  :computers,	:accounts_count, :integer, :null => false, :default => 0
  	add_column  :computers,	:online_accounts_count, :integer, :null => false, :default => 0
  end
end
