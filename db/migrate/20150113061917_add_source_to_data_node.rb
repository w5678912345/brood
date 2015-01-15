class AddSourceToDataNode < ActiveRecord::Migration
  def change
  	add_column :data_nodes, :marked_at, :datetime, null: false
  	add_column :data_nodes, :source, :string, null: false, default: ''
  	add_column :data_nodes, :data,	 :text, null: false, default: '{}'
  end
end
