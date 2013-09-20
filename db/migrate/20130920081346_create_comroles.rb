class CreateComroles < ActiveRecord::Migration
  def change
    create_table :comroles do |t|
      t.integer	  :role_id,		:null => false, :default => 0
      t.integer   :computer_id,	:null => false,	:default => 0
      t.boolean   :normal,		:null => false,	:default => true
      t.timestamps
    end
  end
end
