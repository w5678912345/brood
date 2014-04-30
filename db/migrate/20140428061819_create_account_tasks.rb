class CreateAccountTasks < ActiveRecord::Migration
  def change
    create_table :account_tasks do |t|
      t.string :account, :null => false
      t.string :task,	 :null => false, :default => ""
      t.string :event,	 :null => false, :default => ""
      t.string :status,  :null => false, :default => "doing"
      t.string :result,  :null => false, :default => ""
      t.string :msg
      t.timestamps
    end
  end
end
