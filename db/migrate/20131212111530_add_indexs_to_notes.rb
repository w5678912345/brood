class AddIndexsToNotes < ActiveRecord::Migration
  def change
  	add_index :notes, :account
  	add_index :notes, :computer_id
  	add_index :notes, :role_id
  	add_index :notes, :session_id
  end
end
