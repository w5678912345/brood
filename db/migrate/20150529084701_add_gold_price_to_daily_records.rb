class AddGoldPriceToDailyRecords < ActiveRecord::Migration
  def change
    add_column :daily_records, :gold_price, :integer,:default => 0
  end
end
