# encoding: utf-8
class AddColumnsToAccounts < ActiveRecord::Migration
  def change
  	add_column  :accounts,	:bind_computer_id, :integer, :null => false, :default => -1
  	add_column 	:accounts,	:bind_computer_at, :datetime #
  	add_column  :accounts,	:normal_at, :datetime # 恢复正常的时间
  end
end
