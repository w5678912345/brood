class AddLastAccountToIps < ActiveRecord::Migration
  def change
  	add_column :ips, :last_account, :string ,:null => true
  end
end
