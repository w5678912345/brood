class AddServerForComputers < ActiveRecord::Migration
  def up
  	add_column	:computers,	:server,			:string, :null => true
  end

  def down
  	remove_column :computers ,:server 
  end
end
