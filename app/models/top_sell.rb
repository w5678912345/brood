class TopSell < ActiveRecord::Base
  attr_accessible :gold, :price, :role_name, :server_name, :today_sells_count, :today_sells_sum
  belongs_to :server, :class_name => 'Server', :foreign_key => 'server_name',:primary_key => 'name'
end
