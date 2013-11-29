class AddGoldToServers < ActiveRecord::Migration
  def change
  	add_column  :servers, :gold_price, :float, :null=> false, :default => 0
  	add_column  :servers, :gold_unit,  :float, :null => false, :default => 0
  end
end
