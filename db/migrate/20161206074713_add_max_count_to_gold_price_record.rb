class AddMaxCountToGoldPriceRecord < ActiveRecord::Migration
  def change
    add_column :gold_price_records, :max_count, :integer
  end
end
