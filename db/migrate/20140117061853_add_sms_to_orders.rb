# encoding: utf-8
class AddSmsToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :sms, :string
  	
  end
end
