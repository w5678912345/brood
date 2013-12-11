class AddAutoBindingToComputers < ActiveRecord::Migration
  def change
  	add_column :computers, :auto_binding, :boolean, :null=>false, :default => true
  end
end
