# encoding: utf-8
class AddColumnsToPhones < ActiveRecord::Migration
  def change
  	add_column :phones, :accounts_count, :integer, :null => false, :default => 0
  	add_column :phones, :can_bind,	:boolean, :null => false, :default => true
  	add_column :phones, :status,    :string, :default => "idle"
  	add_column :phones, :sms_count, :integer, :null => false, :default => 0
  	add_column :phones, :today_sms_count, :integer, :null => false, :default => 0

  end
end
