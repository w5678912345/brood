class CreateAccountProfiles < ActiveRecord::Migration
  def change
    create_table :account_profiles do |t|
      t.boolean :enable,:default => false
      t.string :name,:default => ""
      t.text :anti_check_cfg

      t.timestamps
    end
    add_column :accounts, :account_profile_id, :integer,:default => 0
    add_index :accounts, :account_profile_id
  end
end
