class AddHistroyAndRemarkToSettings < ActiveRecord::Migration
  def change
  	add_column :settings, :history, :integer
  	add_column :settings, :remark, :string
  end
end
