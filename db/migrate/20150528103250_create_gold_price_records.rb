class CreateGoldPriceRecords < ActiveRecord::Migration
  def change
    create_table :gold_price_records do |t|
      t.integer :server_id
      t.integer :average_price
      t.integer :max_price

      t.timestamps
    end
    add_index :gold_price_records,:server_id
  end
end
