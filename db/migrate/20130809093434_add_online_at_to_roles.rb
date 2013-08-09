class AddOnlineAtToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :online_note_id, :integer,  :null => false, :default => 0
  	add_column :roles, :online_at,		:datetime, :null => true
  end
end
