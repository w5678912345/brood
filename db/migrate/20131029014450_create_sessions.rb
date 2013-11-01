# encoding: utf-8
class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer   :computer_id, :null => false, :default => 0 # 机器ID
      t.string    :account,		  :null => true					# 账号
      t.integer	  :role_id,     :null => false, :default => 0	# 角色ID
      t.integer   :sup_id,      :null => false, :default => 0 # 上级session
      t.string	  :ip,			    :null => false, :limit => 15  # IP
      t.string    :hostname,    :null => true   # 机器主机名
      t.string 	  :server,		  :null => true   # 服务器
      t.string 	  :version,		  :null => true   # 版本号
      t.string    :game_version,:null => true   # 游戏版本
      t.boolean   :ending,      :null => false, :default => false # 是否结束
      t.datetime  :end_at,		  :null => true		# 结束时间
      t.float     :hours,       :null => false, :default => 0 # 小时数
      t.boolean	  :success,		  :null => false, :default => false # 是否成功
      t.string 	  :code,		    :null => true					# code
      t.string	  :result,		  :null => true					# 结果
      t.string    :status,      :null => false, :default => 'normal'      # 会话状态
      t.integer	  :computer_accounts_count, :null => false, :default => 0 # 机器账号数
      t.integer	  :account_roles_count,		:null => false,	:default => 0 # 账号角色数
      t.string	  :account_roles_ids,		:null => true 				  # 调用的角色ID
      t.integer	  :role_start_level,		:null => false,	:default => 0 # 角色起始等级
      t.integer	  :role_end_level,			:null => false,	:default => 0 # 角色结束等级
      t.integer	  :role_start_gold,			:null => false,	:default => 0 # 角色起始金币
      t.integer	  :role_end_gold,			:null => false,	:default => 0 # 角色结束金币
      t.integer   :trade_gold,				:null => false,	:default => 0 # 当前回话转出的金币
      t.string    :opts,              :null => false, :default => "{}",:limit => 500
      t.string    :events,            :null => false, :default => "{}",:limit => 500
      t.string	  :msg
      t.timestamps
    end
  end
end

