class CreatePhoneMachines < ActiveRecord::Migration
  def change
    create_table :phone_machines do |t|
    	t.string :name,null: false
      t.timestamps
    end
    add_index :phone_machines,:name ,:unique => true
  end
end
