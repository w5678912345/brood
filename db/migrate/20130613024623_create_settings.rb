class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string    :key,       	  :null => false ,:unique => true
      t.integer   :val,	          :null => false ,:default => 1
      t.timestamps
    end
    #
  end

  def self.down
  	drop_table :settings
  end
end
