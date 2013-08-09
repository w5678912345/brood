class AddOnlineAtToNotes < ActiveRecord::Migration
  def change
  	add_column :notes, :online_note_id, :integer,  :null => false, :default => 0
  	add_column :notes, :online_at,:datetime, :null => true
  end
end
