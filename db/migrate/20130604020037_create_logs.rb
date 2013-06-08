# encoding: utf-8
class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer	  :role_id,		  :null => false #
      t.integer   :computer_id,   :null => false #
      t.string	  :ip,			  :null => false #
      t.string 	  :action,		  :null => true
      t.string	  :msg,			  :null => true #
      t.timestamps
    end
  end
end
