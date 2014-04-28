class CreateAccountTasks < ActiveRecord::Migration
  def change
    create_table :account_tasks do |t|
      t.string :account, :null => false
      t.string :task,	 :null => false
      t.string :status,  :null => false, :default => ""
      t.string :result,  :null => false, :default => ""
      t.timestamps
    end
  end
end
