class CreateAccountStatuses < ActiveRecord::Migration
  def change
    create_table :account_statuses do |t|
      t.string :status, :default => false
      t.integer :hours, :default => false,:default=>0

      t.timestamps
    end
    add_index :account_statuses, :status, :unique => true
  end
end
