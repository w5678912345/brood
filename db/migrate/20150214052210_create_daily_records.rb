class CreateDailyRecords < ActiveRecord::Migration
  def change
    create_table :daily_records ,{id: false,primary_key: :date}do |t|
      t.date :date
      t.integer :account_start_count,:default => 0
      t.string :role_start_count,:default => 0
      t.integer :success_role_count,:default => 0
      t.integer :consumed_vit_power_sum,:default => 0, :limit => 8
      t.integer :role_online_hours,:default => 0, :limit => 8
      t.integer :gold,:default => 0, :limit => 8
      t.integer :trade_gold,:default => 0, :limit => 8
      t.integer :bslocked_count,:default => 0
      t.integer :discardforyears_count,:default => 0
      t.integer :discardfordays_count,:default => 0
      t.integer :exception_count,:default => 0
      t.integer :recycle_count,:default => 0
      t.integer :locked_count,:default => 0

      t.timestamps
    end
    add_index :daily_records,:date,unique: true
  end
end
