class CreatePhoneTasks < ActiveRecord::Migration
  def change
    create_table :phone_tasks do |t|
      t.string :phone_id
      t.string :target
      t.string :action
      t.string :msg
      t.string :status,:default => 'waiting'
      t.string :result
      t.timestamps
    end
    add_index :phone_tasks,:phone_id
    add_index :phone_tasks,:status
    add_index :phone_tasks,:action
  end
end
