class AddAutoUnbindToComputers < ActiveRecord::Migration
  def change
  	add_column :computers, :auto_unbind, :boolean, :null=>false, :default => true
  end
end
