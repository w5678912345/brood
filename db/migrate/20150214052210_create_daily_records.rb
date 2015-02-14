class CreateDailyRecords < ActiveRecord::Migration
  def change
    create_table :daily_records ,{id: false,primary_key: :date}do |t|
      t.date :date
      t.integer :account_start_count
      t.string :role_start_count
      t.integer :success_role_count
      t.integer :consumed_vit_power_sum
      t.integer :role_online_hours
      t.integer :gold
      t.integer :trade_gold
      t.integer :bslocked_count
      t.integer :discardforyears_count
      t.integer :discardfordays_count
      t.integer :exception_count
      t.integer :recycle
      t.integer :locked

      t.timestamps
    end
    add_index :daily_records,:date,unique: true
  end
end
