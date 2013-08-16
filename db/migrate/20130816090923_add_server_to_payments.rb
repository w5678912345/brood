class AddServerToPayments < ActiveRecord::Migration
  def change
  	add_column	:payments,	:server,			:string, :null => true
  end
end
