class AddStandingToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :standing, :boolean, :null => false, :default => false
  end
end
