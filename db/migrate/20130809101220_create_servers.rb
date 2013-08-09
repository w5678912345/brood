class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
 	  t.string :name,						:null => false, :limit => 124
      t.string :role_str,					:null => true
      t.integer :roles_count,				:null => false, :default => 0
      t.integer :computers_count,			:null => false, :default => 0
      t.timestamps
    end
    add_index :servers, :name,                :unique => true
    #execute "ALTER TABLE servers ADD PRIMARY KEY (name);"

    #rename_column(roles, "server", "server_name")
	#rename_column(computers, "server", "server_name")


  end
end
