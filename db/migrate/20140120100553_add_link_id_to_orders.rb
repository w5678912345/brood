# encoding: utf-8
class AddLinkIdToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :link_id, :integer, :default=>0
  end
end
