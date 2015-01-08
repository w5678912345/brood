class CreateTicketRecords < ActiveRecord::Migration
  def change
    create_table :ticket_records do |t|
      t.string :account, :null => false
      t.string :server
      t.integer :role_id
      t.string :role_name
      t.integer :points, :null => false, :default => 0
      t.integer :gold, :null => false, :default => 0
      t.string :msg
      t.timestamps
    end
  end
end
