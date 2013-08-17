# encoding: utf-8
class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string 	  :user_id,			:null => false
      t.integer	  :role_id,			:null => false, :default => 0
      t.integer   :computer_id,	:null => false,	:default => 0
      t.integer	  :sup_id,		  :null => false, :default => 0
      t.string    :name,		    :null => false
      t.string 	  :command,			:null => true
      t.string 	  :args,			  :null => true
      t.string 	  :code,			  :null => true
      t.string 	  :remark,			:null => true
      t.boolean   :pushed,			:null => false,	:default => false
      t.datetime  :pushed_at,		:null => true
      t.boolean   :callback,    :null => false, :default => false
      t.datetime  :callback_at,	:null => true
      t.string	  :msg,				  :null => true
      t.boolean   :success,			:null => false,	:default => false
     
      t.timestamps
    end
  end
end
