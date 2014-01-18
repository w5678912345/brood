# encoding: utf-8
class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :phone_no, :null => false, :limit => 32
      t.string :event,    :null => false, :limit => 32
      t.string :status,   :null => false, :limit => 32, :default => "idle"
      t.string :link_type, :null => false, :limit => 32, :default => "send"
      t.integer :sms_count, :null => false, :default => 0
      t.integer :today_sms_count, :null => false, :default => 0
      t.integer :timeout_count, :null => false, :default => 0 
      t.integer :today_timeout_count, :null => false, :default => 0
      
      t.timestamps
    end
    add_index :links, [:phone_no, :event],unique: true

  end
end
