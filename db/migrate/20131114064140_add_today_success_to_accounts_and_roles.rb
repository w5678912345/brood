# encoding: utf-8
class AddTodaySuccessToAccountsAndRoles < ActiveRecord::Migration
  def change
  	add_column  :accounts,	:today_success, :boolean, :null=> false, :default => false
  	add_column  :accounts,	:current_role_id, :integer, :null => false, :default => 0
  	add_column  :roles,		:today_success, :boolean, :null=> false, :default => false
  end
end
