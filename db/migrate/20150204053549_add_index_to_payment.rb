class AddIndexToPayment < ActiveRecord::Migration
  def change
    add_index :payments,[:role_id,:note_id]
  end
end
