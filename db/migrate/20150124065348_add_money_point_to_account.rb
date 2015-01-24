class AddMoneyPointToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :money_point, :integer,default: 0
  end
end
