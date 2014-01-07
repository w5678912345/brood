class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones ,{:id =>false} do |t|
      t.string :no, :null => false
      t.boolean :enabled, :null => false,:default => true
      t.datetime :last_active_at
      t.belongs_to :phone_machine
      t.timestamps
    end
    add_index :phones,:no ,:unique => true
    execute "ALTER TABLE phones ADD PRIMARY KEY (no);"
  end
end
