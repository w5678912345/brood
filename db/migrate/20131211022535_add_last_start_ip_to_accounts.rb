class AddLastStartIpToAccounts < ActiveRecord::Migration
  def change
  	add_column  :accounts, :last_start_ip, :string, :null => true, :limit => 32
  end
end
