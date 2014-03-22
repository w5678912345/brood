class AddTargetToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :target_no, :string
  end
end
