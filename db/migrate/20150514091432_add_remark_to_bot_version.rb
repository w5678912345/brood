class AddRemarkToBotVersion < ActiveRecord::Migration
  def change
    add_column :bot_versions, :remark, :string
  end
end
