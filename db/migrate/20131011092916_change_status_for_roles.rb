class ChangeStatusForRoles < ActiveRecord::Migration
  def up
  	change_column :roles, :status, :string, :default => 'normal'
  end

  def down
  	change_column :roles, :status, :integer,:default => 1
  end

end
