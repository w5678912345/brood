class AddProfessionToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :profession, :string, :null => false, :default => ''
  end
end
