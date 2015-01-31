class AddMsgToComputer < ActiveRecord::Migration
  def change
    add_column :computers, :msg, :string
  end
end
