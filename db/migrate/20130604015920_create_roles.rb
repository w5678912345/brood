# encoding: utf-8
class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string    :account,		    :null => false
      t.string    :password,      :null => false 
      t.string    :name,					:null => false #
      t.string 	  :server,				:null => false #
      t.integer   :level,					:null => false ,:default => 0
      t.integer   :tired_value,		:null => false ,:default => 0
      t.integer   :status,				:null => false ,:default => 1
      # about online
      t.integer   :computer_id,   :null => false ,:default => 0 # if > 0 desc online
      t.integer   :count,         :null => false ,:default => 0 #
      t.boolean   :online,        :null => false ,:default => false
      t.string    :ip,            :null => true  ,:limit => 15
      #
      t.integer   :gold,          :null => true  ,:default => 0
      t.timestamps
    end
     
  end
end
