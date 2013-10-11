# encoding: utf-8
# 20131009053107
class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string 	  :no,		  :null => false
      t.string    :password,      :null => false
      t.string	  :server,		  :null => true
      t.integer	  :roles_count,	  :null => false, :default => 0
      t.integer   :computers_count,	:null => false, :default => 0
      t.boolean	  :normal,			:null => false,	:default => true
      t.string	  :status,			:null => false,	:default => 'normal'
      t.string 	  :ip_range,		:null => true
      #
      t.string	  :online_ip,			    :null => true
      t.integer   :online_note_id,    :null => false, :default => 0 # 在线记录ID
      t.integer	  :online_role_id,		:null => false,	:default => 0 # 当前在线角色ID
      t.integer	  :online_computer_id,	:null => false, :default => 0 # 大于0 表示帐号在线的机器ID,等于0表示帐号不在线
      

      t.timestamps
    end

    add_index :accounts, :no,                :unique => true
    add_index :accounts, :status
    add_index :accounts, :server
  end
end
