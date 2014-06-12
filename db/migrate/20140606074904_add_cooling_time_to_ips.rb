class AddCoolingTimeToIps < ActiveRecord::Migration
  def change
  	add_column :ips, :cooling_time, :datetime
  	add_index :ips,	:cooling_time
  end
end
