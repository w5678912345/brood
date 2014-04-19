class AddEnabledToLinks < ActiveRecord::Migration
  def change
  	add_column :links, :enabled, :boolean,:null => false, :default => true
  end
end
