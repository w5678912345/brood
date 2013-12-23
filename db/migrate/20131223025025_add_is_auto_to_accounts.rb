class AddIsAutoToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :remark, :string, :null => true
  	add_column :accounts, :is_auto, :boolean, :null => false, :default => false
  end
end
