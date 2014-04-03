class AddRealNameToComputers < ActiveRecord::Migration
  def change
  	add_column :computers, :real_name, :string, :null=>true
  end
end
