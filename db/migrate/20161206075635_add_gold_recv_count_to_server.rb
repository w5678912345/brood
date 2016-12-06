class AddGoldRecvCountToServer < ActiveRecord::Migration
  def change
    add_column :servers, :gold_recv_count, :integer
  end
end
