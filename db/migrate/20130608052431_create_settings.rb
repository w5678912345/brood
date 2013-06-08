class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer		:max_roles_count_by_computer	,:null => false, :default => 5
      t.integer 	:max_roles_count_by_id			,:null => false, :default => 5
      t.integer		:timeout_minutes,				,:null => false, :default => 10
      
      t.timestamps
    end
  end
end
