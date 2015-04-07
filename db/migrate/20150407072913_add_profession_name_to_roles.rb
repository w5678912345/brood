class AddProfessionNameToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :profession_name, :string
    add_index :roles, :profession_name
  end
end
