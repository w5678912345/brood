class AddTotalCashboxToDailyRecords < ActiveRecord::Migration
  def change
    add_column :daily_records, :total_cashbox, :integer, :default => 0, :limit => 8
  end
end
