class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer   :user_id,       :null => false ,:default => 0
      t.integer	  :role_id,       :null => false ,:default => 0
      t.integer   :computer_id,   :null => false ,:default => 0
      t.string	  :ip,			      :null => false ,:limit => 15
      t.string    :api_name,      :null => false
      t.string    :api_code,      :null => false ,:default => 0
      t.string 	  :action,		    :null => true
      t.string	  :msg,			      :null => true #
      t.timestamps
    end
  end
end
