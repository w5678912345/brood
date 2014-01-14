class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :phone_no
      t.string :account_no
      t.boolean :pulled, :null => false, :default => false
      t.boolean :sent, :null => false, :default => false
      t.boolean :finished, :null => false, :default => false
      t.datetime :pulled_at
      t.datetime :sent_at
      t.datetime :finished_at
      t.string :trigger_event
      t.string :status
      t.timestamps
    end
  end
end
