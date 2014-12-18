class CreateIpRanges < ActiveRecord::Migration
  def change
    create_table :ip_ranges do |t|
      t.string :ip, :null => false
      t.integer :start_count
      t.integer :minutes
      t.integer :online_count
      t.integer :ip_accounts_in_24_hours
      t.boolean :enabled, :null => false ,:default => false
      t.string :remark

      t.timestamps
    end
  end
end
