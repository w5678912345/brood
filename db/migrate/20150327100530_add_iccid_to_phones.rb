class AddIccidToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :iccid, :string
    add_index :phones, :iccid

    add_column :phones, :online, :boolean,:default => false
    add_index :phones, :online
  end
end
