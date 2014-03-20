class AddAllowedNewToServers < ActiveRecord::Migration
  def change
  	add_column :servers, :allowed_new, :boolean, :null=>false, :default => true
  end
end
