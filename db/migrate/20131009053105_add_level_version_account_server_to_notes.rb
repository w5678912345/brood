class AddLevelVersionAccountServerToNotes < ActiveRecord::Migration
  def change
  	add_column  :notes,	:level,	:integer
  	add_column  :notes,	:version, :string
  	add_column  :notes,	:account, :string
  	add_column	:notes,	:server,  :string
  end
end
