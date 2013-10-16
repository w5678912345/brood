# encoding: utf-8
class AddColumnsToAccounts < ActiveRecord::Migration
  def change
  	add_column  :accounts,	:bind_computer_id, :integer, :null => false, :default => 0
  	add_column 	:accounts,	:bind_computer_at, :datetime
  end
end
