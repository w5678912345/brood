class CreateDataNodes < ActiveRecord::Migration
  def change
    create_table :data_nodes do |t|
      t.string    :computers,             :null => false, :default => "{}",:limit => 500
      t.string    :accounts,              :null => false, :default => "{}",:limit => 500
      t.string    :roles,              	  :null => false, :default => "{}",:limit => 500
      t.string 	  :events,				  :null => false, :default => "{}",:limit => 500
	  t.string 	  :opts,				  :null => false, :default => "{}",:limit => 500 
      t.timestamps
    end
  end
end
