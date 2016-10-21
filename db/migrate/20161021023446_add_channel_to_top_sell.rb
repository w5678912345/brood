class AddChannelToTopSell < ActiveRecord::Migration
  def change
    add_column :top_sells, :channel, :integer,:default => 10
  end
end
