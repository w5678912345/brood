# encoding: utf-8
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
      t.string	  :online_ip,			:null => true
      t.integer   :online_note_id,    :null => false, :default => 0 # 在线记录ID
      t.integer	  :online_role_id,		:null => false,	:default => 0 # 当前在线角色ID
      t.integer	  :online_computer_id,	:null => false, :default => 0 # 大于0 表示帐号在线的机器ID,等于0表示帐号不在线
      

      # t.boolean	  :closed,			:null => false,	:default => false
      # t.integer	  :close_hours,		:null => false,	:default => 2

      # t.boolean   :locked,			:null => false,	:default => false
      # t.boolean	  :lost,			:null => false, :default => false
      # t.boolean   :bslocked,		:null => false,	:default => false
      # t.boolean	  :unbslock_result,	:null => true

       


      #  t.string    :account,		    :null => false
      # t.string    :password,      :null => false 
      # t.integer   :role_index,		:null => true #
      # t.string 	  :server,				:null => true #
      # t.integer   :level,					:null => false ,:default => 0
      # t.integer   :vit_power,		  :null => false ,:default => 0
      # t.integer   :status,				:null => false ,:default => 1
      # # about online
      # t.integer   :computer_id,   :null => false ,:default => 0 # if > 0 desc online
      # t.integer   :count,         :null => false ,:default => 0 #
      # t.boolean   :online,        :null => false ,:default => false
      # t.string    :ip,            :null => true  ,:limit => 15
      # #
      # t.integer   :gold,          :null => true  ,:default => 0

      t.timestamps
    end

    add_index :accounts, :no,                :unique => true
    add_index :accounts, :status
    add_index :accounts, :server
  end
end
