class TopSell < ActiveRecord::Base
  attr_accessible :goods, :price, :role_name, :server_name, :today_sells_count, :today_sells_sum,:enable
  belongs_to :server, :class_name => 'Server', :foreign_key => 'server_name',:primary_key => 'name'
  def self.reset_daily_statistic
    self.update_all(:today_sells_count => 0,:today_sells_sum => 0)
  end
end
