class AddAverageLevelToDailyRecords < ActiveRecord::Migration
  def change
    add_column :daily_records, :average_level, :integer,default: 0
  end
end
