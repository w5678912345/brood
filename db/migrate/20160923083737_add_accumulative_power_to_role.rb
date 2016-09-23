class AddAccumulativePowerToRole < ActiveRecord::Migration
  def change
    add_column :roles, :accumulative_power, :integer,:default => 0
  end
end
