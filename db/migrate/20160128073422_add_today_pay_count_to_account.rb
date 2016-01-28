class AddTodayPayCountToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :today_pay_count, :integer,:default => 0
  end
end
