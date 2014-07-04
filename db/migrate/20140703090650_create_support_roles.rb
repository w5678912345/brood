class CreateSupportRoles < ActiveRecord::Migration
  def change
    create_table :support_roles do |t|
      t.string :name, :null => false
      t.string :server, :null => false
      t.string :line
      t.string :status

      t.timestamps
    end
  end
end
