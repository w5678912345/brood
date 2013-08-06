class AddIsSellerToRoles < ActiveRecord::Migration
  def change
  	add_column	:roles,	:is_seller,			:boolean, :null => false,:default => false
  end
end
