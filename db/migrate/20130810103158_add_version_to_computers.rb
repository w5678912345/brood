class AddVersionToComputers < ActiveRecord::Migration
  def change
  	add_column :computers, :version,		:string, :null => false, :default => "default"
  end
end
