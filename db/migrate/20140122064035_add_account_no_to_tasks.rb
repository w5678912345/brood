# encoding: utf-8
class AddAccountNoToTasks < ActiveRecord::Migration
  def change
  	add_column :tasks, :account_no, :string , :null => true, :limit=>32
  	add_column :tasks, :log_at,  :datetime, :null => true
  end
end
