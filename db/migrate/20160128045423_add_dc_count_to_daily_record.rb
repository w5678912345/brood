class AddDcCountToDailyRecord < ActiveRecord::Migration
  def change
    add_column :daily_records, :dc_count, :integer,:default => 0
  end
end
