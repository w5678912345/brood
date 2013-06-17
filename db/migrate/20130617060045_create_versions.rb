class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string		:no,						  :null => false,:unique => true
      t.string 		:zip,						  :null => false
      t.integer     :user_id,					  :null => false
      t.boolean     :released,					  :null => false, :default => false
      t.time  		:released_at,				  :null => true
      t.integer		:release_user_id,			  :null => true
      t.string 		:remark,					  :null => true

      t.timestamps
    end
  end
end
