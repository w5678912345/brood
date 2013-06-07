# encoding: utf-8
class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
      t.string  :hostname,				:null => false
      t.integer :user_id,				  :null => false
      t.string	:auth_key,				:null => false ,:unique => true
      t.integer :status,				  :null => false ,:default => 1
      t.integer :roles_count,		  :null => false ,:default => 0
      t.timestamps
    end
  end
end
