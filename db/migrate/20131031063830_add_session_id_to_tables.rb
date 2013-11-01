# encoding: utf-8
class AddSessionIdToTables < ActiveRecord::Migration
  def change
	add_column  :computers,	:session_id, :integer, :null=> false, :default => 0
	add_column  :accounts,	:session_id, :integer, :null=> false, :default => 0
	add_column  :roles,	:session_id, :integer, :null=> false, :default => 0
	add_column  :notes,	:session_id, :integer, :null=> false, :default => 0
	
  end
end
