class AddColumnsToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :result, :string, :limit=>64
  	add_column :orders, :msg, :string, :limit=>128
  end
end
