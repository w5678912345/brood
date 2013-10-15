class CreateComputerAccounts < ActiveRecord::Migration
  def change
    create_table :computer_accounts do |t|
      t.integer   :computer_id,	:null => false
      t.string	  :account_no,	:null => false
      t.timestamps
    end

    add_index :computer_accounts, [:computer_id,:account_no],unique: true

  end
end
