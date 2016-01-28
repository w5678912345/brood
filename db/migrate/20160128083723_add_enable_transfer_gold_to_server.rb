class AddEnableTransferGoldToServer < ActiveRecord::Migration
  def change
    add_column :servers, :enable_transfer_gold, :boolean,:default => true
  end
end
