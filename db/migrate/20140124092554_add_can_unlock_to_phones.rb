class AddCanUnlockToPhones < ActiveRecord::Migration
  def change
  	add_column :phones, :can_unlock, :boolean, :null => false, :default => true
  	add_column :phones, :unlock_count, :integer, :null => false, :default => 0
  end
end
