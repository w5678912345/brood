class AddEnableToTopSells < ActiveRecord::Migration
  def change
    add_column :top_sells, :enable, :boolean,:default => true
  end
end
