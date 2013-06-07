class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.integer		:uploader_id,				  :null => false
      t.integer		:importer_id,				  :null => true
      t.string		:file,						  :null => false
      t.string 		:remark,					  :null => true
      t.boolean		:imported,					  :null => false,:default => false
      t.datetime	:imported_at,				  :null => true
      t.integer		:import_count,				  :null => false,:default => 0

      t.timestamps
    end
  end
end
