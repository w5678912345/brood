class CreateTopSells < ActiveRecord::Migration
  def change
    create_table :top_sells do |t|
      t.string :server_name,:null => false
      t.string :role_name,:null => false
      t.string :goods
      t.integer :price,:null => false
      t.integer :today_sells_count,:default => 0
      t.integer :today_sells_sum,:limit => 8,:default => 0

      t.timestamps
    end
    add_index :top_sells, [:server_name]
    add_index :top_sells, [:server_name,:role_name]
  end
end
