class AddHostnameToNotes < ActiveRecord::Migration
  def change
  	add_column  :notes,	:hostname, :string
  end
end
