class AddOnlineHoursToNotes < ActiveRecord::Migration
  def change
  	add_column :notes, :online_hours,:float, :null => false,:default => 0
  end
end
