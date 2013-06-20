class AddCheckedForComputers < ActiveRecord::Migration
  def up
		add_column :computers, :checked, 				:boolean,		:null => false,:default => false
		add_column :computers, :check_user_id, 	:integer, 	:null => true, :default => 0
		add_column :computers, :checked_at, 		:datetime,	:null => true
  end

  def down
		remove_column :computers, :checked
		remove_column :computers, :check_user_id
		remove_column :computers,	:checked_at
  end
end
